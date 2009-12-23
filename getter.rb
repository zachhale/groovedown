require "rubygems"
require "restclient"
require "hpricot"
require "json"

query = "Yoshimi Battles The Pink Robot pt 1"
search_type = "Songs"

# find me some results
req = {
  "header" => {
    "clientRevision" => "20091209.02",
    "client" => "gslite"},
  "parameters" => {
    "query" => query,
    "type" => search_type},
  "method" => "getSearchResults"
}
resp = RestClient.post("http://cowbell.grooveshark.com/more.php?getSearchResults", req.to_json, :content_type => "application/json")
songs = JSON.parse(resp)

# pick the first song
song = songs["result"]["Return"].first
puts "We found #{song["SongName"]}!"

# go get streaming details
song_id = song["SongID"].to_i
req = {
  "header" => {
    "clientRevision" => "20091209.02",
    "client" => "gslite"},
  "parameters" => {
    "songID" => song_id,
    "prefetch" => false},
  "method" => "getStreamKeyFromSongID"
}
resp = RestClient.post("http://cowbell.grooveshark.com/more.php?getStreamKeyFromSongID", req.to_json, :content_type => "application/json")
result = JSON.parse(resp)["result"]["result"]

# If this was all successful the following POST should return a stream.  Chunk that shit out to /dev/audio dawg"
streamKey = result["streamKey"]
streamServer = result["streamServer"]
streamUrl = "http://#{streamServer}/stream.php"

puts "Downloading..."

filename = File.join(File.dirname(__FILE__), "#{song["SongName"]}.mp3")
File.open(filename, "w") do |file|
  file << RestClient.post(streamUrl, :streamKey => streamKey, :content_type => "application/x-www-form-urlencoded")
end

puts "Done!"
puts filename
# FIXME:  This needs an overhaul.
# We shouldn't depend on ruby to do the chunking, proxing, and handling seeks.
# Just grab a stream and forward on to the client.  Digging into HAproxy guts :-\
class Stream
  attr_reader :song_id, :server, :key
  
  def initialize(song_id)
    @song_id = song_id
		request = { "header" => { "clientRevision" => "20091209.02", "client" => "gslite"}, "parameters" => { "songID" => @song_id.to_i, "prefetch" => false }, "method" => "getStreamKeyFromSongID" }

    response = RestClient.post("http://cowbell.grooveshark.com/more.php?getStreamKeyFromSongID", 
                               request.to_json, 
                               :content_type => "application/json")

		@stream_result = JSON.parse(response)["result"]["result"]
		@key = @stream_result["streamKey"]
		@server = @stream_result["streamServer"]
  end

end
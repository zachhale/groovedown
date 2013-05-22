require 'ostruct'

class Result < OpenStruct
  def self.find(params)
    search_query = params['query']
    search_type = params['type']

    request = {
      "header" => {
        "clientRevision" => "20091209.02",
        "client" => "gslite"},
      "parameters" => {
        "query" => search_query,
        "type" => search_type},
      "method" => "getSearchResults"
    }

    response = RestClient.post("http://cowbell.grooveshark.com/more.php?getSearchResults",
                               request.to_json, :content_type => "application/json")

    JSON.parse(response)['result']['Return'].map do |song|
      Result.new(:artist_name => song['ArtistName'],
                 :name => song['SongName'],
                 :track_num => song['TrackNum'],
                 :score => song['Score'],
                 :length => song['EstimateDuration'],
                 :song_id => song['SongID'],
                 :year => song['Year'])
    end
  end
end
class Stream
  attr_reader :id
  
  def initialize(id)
    @id = id
  end
  
  def get
    song_id = @id.to_i
    
    request = {
      "header" => {
        "clientRevision" => "20091209.02",
        "client" => "gslite"},
      "parameters" => {
        "songID" => song_id,
        "prefetch" => false},
      "method" => "getStreamKeyFromSongID"
    }
    
    response = RestClient.post("http://cowbell.grooveshark.com/more.php?getStreamKeyFromSongID", 
                               Yajl::Encoder.encode(request), 
                               :content_type => "application/json")
    stream_result = Yajl::Parser.parse(response)["result"]["result"]
    
    stream_key = stream_result["streamKey"]
    stream_server = stream_result["streamServer"]
    stream_url = "http://#{stream_server}/stream.php"
    
    if stream_key
      RestClient.post(stream_url, 
                      :streamKey => stream_key, 
                      :content_type => "application/x-www-form-urlencoded")
    end
  end
end
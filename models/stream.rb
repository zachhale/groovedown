# FIXME:  This needs an overhaul.
# We shouldn't depend on ruby to do the chunking, proxing, and handling seeks.
# Just grab a stream and forward on to the client.  Digging into HAproxy guts :-\
class Stream
  attr_reader :song_id
  
  def initialize(song_id)
    @song_id = song_id
		request = { "header" => { "clientRevision" => "20091209.02", "client" => "gslite"}, "parameters" => { "songID" => @song_id.to_i, "prefetch" => false }, "method" => "getStreamKeyFromSongID" }

    response = RestClient.post("http://cowbell.grooveshark.com/more.php?getStreamKeyFromSongID", 
                               request.to_json, 
                               :content_type => "application/json")

		@stream_result = JSON.parse(response)["result"]["result"]
		@stream_key = @stream_result["streamKey"]
		@stream_server = @stream_result["streamServer"]
		@stream_url = "http://#{@stream_server}/stream.php"
  end

  def get
  	if @stream_key
      RestClient.post(@stream_url, :steamKey => @stream_key, :content_type => "application/x-www-form-urlencoded")
	  end
  end

  def length
  	@length.to_s ||= "0"
  end  

  def each
    url = URI.parse(@stream_url)	
		req = Net::HTTP::Post.new(url.path)
		req.set_form_data({'streamKey' => @stream_key})
		
	  #http = Net::HTTP.new(url.host, url.port)
	  #puts "curl -v -d 'streamKey=#{@stream_key}' #{@stream_url}"
	  #http.post(url.path, "streamKey=#{@stream_key}") do |chunk|
		#  @length = 0 if @length.nil?
		#  @length = chunk.size+4096
		#  #p @length
		#  p chunk.content_length
		#  yield chunk
		#end
			
		Net::HTTP.new(url.host, url.port).start do |http| 
			http.request(req) do |res|
        @length = res.content_length				
				
				res.read_body do |chunk|
					@length = @length# - chunk.size
				  yield chunk.to_s
        end

			end
		end
		
  end

end
require 'net/https'
require 'uri'

class User

  #Process twitter timeline returning a hashed count of tweeted words
  def processTimeline(timeline)
    timeline_words = Array.new()  
    timeline.each do |t_line|
      t_line["text"].strip.each(' ') {|s| timeline_words << s.strip}
    end
    timeline_words.sort
    sortedHash = Hash.new(0)
    timeline_words.each do |word|
      sortedHash[word] += 1
    end
    sortedHash.sort_by { |k,v| v }.reverse
  end


  #Find twitter user info by username
  def findUserByName(username)
    path = APP_CONFIG['searchPath'].gsub('**USERNAME**',username)
    json = makeHttpRequest(path)

    json
  end

  #Get twitter user timeline
  def getUserTimeline(username)
    path = APP_CONFIG['timelinePath'].gsub('**USERNAME**',username)
    json = makeHttpRequest(path)

    json
  end

  #Make https request
  def makeHttpRequest(path)
    url = URI.parse(APP_CONFIG['searchUrl'])
    http= Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(path, initheader = {'Content-Type' =>'application/json'})
    res = http.start {|http| 
      http.request(req) 
    }
    res.body
  end

end
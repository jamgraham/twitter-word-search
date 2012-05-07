class UserController < ApplicationController
  
  def twitter
    
    #Validate twitter username is not blank
    if (params["twitter_user_name"].to_s.empty?)
      flash[:error] = "Twitter username is invalid."
         redirect_to '/user'
         return 
    end
    
    user = User.new()
    twitter_user_info = user.findUserByName(params["twitter_user_name"])
    @twitter_user_info = ActiveSupport::JSON.decode(twitter_user_info)

    #Validate twitter username was found
    if @twitter_user_info['error'] == 'Not found'
      flash[:error] = "Twitter username not found."
         redirect_to '/user'
         return
    end
    
    #Get twitter user timeline
    twitter_timeline = user.getUserTimeline(params["twitter_user_name"])
    @twitter_timeline = ActiveSupport::JSON.decode(twitter_timeline)
    
    #Process twitter timeline returning a hashed count of tweeted words
    @twitter_timeline_words = user.processTimeline(@twitter_timeline)
    
    @twitter_user_info
  end
  
end

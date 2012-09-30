class HomeController < ApplicationController
  def index
  	app_id = "367333956679167"
    app_secret ="790cb4afc91ea9aa8949ec944af62f2e"
    callback_url = "http://localhost:3000/"
    @oauth = Koala::Facebook::OAuth.new(app_id, app_secret, callback_url)
    @redirect_url = "https://graph.facebook.com/oauth/authorize?client_id="+app_id+"& redirect_url="+@oauth.url_for_oauth_code(:permissions =>"user_status,friends_status,publish_stream")+"&auth_type=reauthenticate"
    @message = "Log In with faceboook"     
    if params["code"]
      @token = @oauth.get_access_token(params["code"]) 
      @message = "done"  
      @graph = Koala::Facebook::API.new(@token)
      @user  = @graph.get_object("me")          
      @fb_user_id =@user["id"]   
      target_id = 1241641191    
      makeFbrequests 
      postStatus  target_id     
    end 
  end
  def makeFbrequests
    if params["code"]            
      @friends = @graph.graph_call("me/friends")      
      @message ="done" 
    end 
  end  
  def postStatus target_id
      #@graph.put_wall_post("testing facebook graphi api ...heeya!")
      options = {}
      attachment = {}
      #@graph.put_connections(target_id, "feed", attachment.merge({:message => "testing facebook graphi api ...heeya!"}), options)
  end  
end

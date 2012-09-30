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
      session["token"] = params["code"]  
      if  !session["message"].nil?
        postStatus session["message"]
      end  
    end 
    #redirect_to request.original_url+"/lib/"+session["lib_id"].to_str
  end
  def makeFbrequest
    if params["code"]            
      @friends = @graph.graph_call("me/friends")      
      @message ="done" 
    end 
  end  
  def postStatus message
    if message.length > 0      
      @graph.put_wall_post(message.to_str)
    end        
  end 
  def get_full_lib(lib)
    frame_text = lib.frame_text.split("|")
    keyword_text = lib.keyword_text.split("|")
    keyword_array = lib.keyword_array.split("|")
    value_array = lib.value_array.split("|")

    logger.debug("frame text:#{frame_text}")
    logger.debug("keyword text:#{keyword_text}")
    logger.debug("keyword array:#{keyword_array}")
    logger.debug("value array:#{value_array}")

    key_value_map = {}
    keyword_array.each_index do |i|
      key_value_map[keyword_array[i]] = value_array[i]
    end
    
    logger.debug("key value map: #{key_value_map}") #works

    finalstring = ""
    frame_text.each_index do |i|
      begin
        trimmed_keyword = keyword_text[i][1..keyword_text[i].length-2]
        finalstring = finalstring + frame_text[i] +key_value_map[trimmed_keyword]
      rescue
        finalstring = finalstring + frame_text[i]
      end

    end

    #logger.debug("finalstring: #{finalstring}")

    return finalstring.html_safe
    
  end 
end

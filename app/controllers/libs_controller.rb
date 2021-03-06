class LibsController < ApplicationController

  # GET /libs
  # GET /libs.json
  def index
    @libs = Lib.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @libs }
    end
  end

  # GET /libs/1
  # GET /libs/1.json
  def show
    @lib = Lib.find(params[:id])
    @fullstring = get_full_lib(@lib)
    session["message"] =  @finalstring_nohtml
    session["lib_id"] = params[:id]
    app_id = "367333956679167"
    app_secret ="790cb4afc91ea9aa8949ec944af62f2e"
    callback_url = "http://localhost:3000"  
    @oauth = Koala::Facebook::OAuth.new(app_id, app_secret, callback_url)
    @redirect_url = "https://graph.facebook.com/oauth/authorize?client_id="+app_id+"& redirect_url="+@oauth.url_for_oauth_code(:permissions =>"user_status,friends_status,publish_stream")+"&auth_type=reauthenticate"           
  end

  # GET /libs/new
  # GET /libs/new.json
  def new
    @lib = Lib.new
    
    templates = []
    templates.append('One day, [person1] and [person2] went to [place]. [person1] was [adjective] that fateful day. Because of that, suddenly, a [color] [noun] appeared and started [ing verb]. [person1] [past tense of verb], and [person2] decided to [verb] a [noun2]. That fixed everything, no one was hurt. The end.')
    templates.append('This year our class is doing a special science project. We have a [person1] that we are taking care of. It is very [adjective] and it has [color] [body part]. It lives in a [noun] in the back of our classroom. We feed it [food] and [drink] every day, but I think it really wants to eat my [noun2]. Everyone likes our [person1]. One day, the [person1] got out of its cage and started [verb]ing all around the room. I think it was trying to say, [exclamation]!')
    templates.append('[person1], [person2], and [person3] were in a [mode of transportation] together. [person1] liked eating [food], [person2] liked [color] [noun]s, and [person3] was busy [verb]ing. After a few minutes, the [mode of transportation] arrived at its final destination, [place]. All three friends got out, and started [verb2]ing. [adjective] [noun2]s were everywhere. It was a glorious day.')
    templates.append('Meet our hero [person1], a super-intelligent [profession]. A run in with the evil villain [person2] leads [person1] to create his alter ego, a [color] [adjective] giant capable of great destruction. He [adverb] battles [person2] with his girlfriend [person3]. Eventually, it is discovered that [person3], distinguished by her [facial feature], is actually trying to destroy [city] with evil villain [person2]. Eventually, the enemy is subdued by [verb]ing him with a [noun]. All is good in this world, once again.')
    templates.append('Dear [person1]. I enjoy [adjective] walks on the beach, and serendipitous encounters with [plural noun]. I really like [drink] mixed with [fruit], and romantic candle-lit [noun]. I am well-read, from Dr. Seuss to [famous person]. I travel frequently, especially to [country] where I like to [verb]. I am looking for love in the form of a [adjective2] goddess. She should have the physique of [person2], espcially the [body part]. I would prefer if she knew how to cook, clean, [verb], and wash my [noun3]s. I know I am not very attractive in my picture, but it was taken [number] years ago, and I have since become more [adjective3]')
    templates.append('[person1], [person2], and I are best friends. We love to [verb] our [noun2]s together. One day, our friendship was tested. A [natural disaster] occured and people were being hurt by [adjective] [noun]s. At first, we were all [emotion adjective], but then we realized we had to stop the [adjective] [noun]s. It was not easy, but we finally did it by [verb2]ing [adjective2] [noun3]s. Now, we could finally [verb] our [noun2]s in peace.')

    r = Random.new
    template_index = r.rand(0..templates.count-1)
    template = templates[template_index]
    logger.debug("selected template: #{template}")

    @frame_text = template.split(/\[[a-z0-9\s]*\]/)
    @keyword_text = template.scan(/\[[a-z0-9\s]*\]/)
    @keyword_set = @keyword_text.to_set

    logger.debug("frame text: #{@frame_text}")
    logger.debug("keyword text: #{@keyword_text}")
    

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lib }
    end
  end

  # GET /libs/1/edit
  def edit
    @lib = Lib.find(params[:id])
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
    @finalstring_nohtml =""
    frame_text.each_index do |i|
      begin
        trimmed_keyword = keyword_text[i][1..keyword_text[i].length-2]
        finalstring = finalstring + frame_text[i] + '<span class="keyword">'+key_value_map[trimmed_keyword]+'</span>'
        @finalstring_nohtml =  @finalstring_nohtml + frame_text[i] +key_value_map[trimmed_keyword]
      rescue
        finalstring = finalstring + frame_text[i]
        @finalstring_nohtml =  @finalstring_nohtml + frame_text[i]
      end

    end

    #logger.debug("finalstring: #{finalstring}")

    return finalstring.html_safe
    
  end

  def create_lib
    if request.post?
      logger.debug("params: #{params}") 
      @lib = Lib.new
      
      frame_text = params[:frame_text]
      keyword_text = params[:keyword_text]

      @lib.update_attribute(:frame_text, frame_text)
      @lib.update_attribute(:keyword_text, keyword_text)

      keyword_hash = params[:form]
      keyword_array = []
      value_array = []
      @people = []
      keyword_hash.each_pair do |key,value| 
        if key.to_s.include?("person")
          @people.insert(value.to_s)
        end    
        keyword_array.append(key)
        value_array.append(value)
      end
      logger.debug("frame text: #{frame_text}")
      logger.debug("keyword text: #{keyword_text}")
      logger.debug("keyword array: #{keyword_array}")
      logger.debug("value array: #{value_array}")

      @lib.update_attribute(:keyword_array, keyword_array.join('|'))
      @lib.update_attribute(:value_array, value_array.join('|'))

      @lib.save     
      session["people"] = @people 
      redirect_to @lib, notice: 'Lib was successfully created.'
    else

    end

  end

  # POST /libs
  # POST /libs.json

  def create


    #@lib = Lib.new(params[:lib])

    respond_to do |format|
      if @lib.save
        format.html { redirect_to @lib, notice: 'Lib was successfully created.' }
        format.json { render json: @lib, status: :created, location: @lib }
      else
        format.html { render action: "new" }
        format.json { render json: @lib.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /libs/1
  # PUT /libs/1.json
  def update
    @lib = Lib.find(params[:id])

    respond_to do |format|
      if @lib.update_attributes(params[:lib])
        format.html { redirect_to @lib, notice: 'Lib was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lib.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /libs/1
  # DELETE /libs/1.json
  def destroy
    @lib = Lib.find(params[:id])
    @lib.destroy

    respond_to do |format|
      format.html { redirect_to libs_url }
      format.json { head :no_content }
    end
  end
  def makeFbrequests
    if params["code"]            
      @friends = @graph.graph_call("me/friends")      
      @message ="done" 
    end 
  end  
  def postStatus(message)
    app_id = "367333956679167"
    app_secret ="790cb4afc91ea9aa8949ec944af62f2e"
    callback_url = "http://localhost:3000/"
    @oauth = Koala::Facebook::OAuth.new(app_id, app_secret, callback_url)
    @token = @oauth.get_access_token(session["token"])     
    @graph = Koala::Facebook::API.new(@token)    
    @graph.put_wall_post(message, {"tags" => "1241641191","place"=>"108424279189115"},"me")
    #options = {}
    #attachment = {}
      #@graph.put_connections(target_id, "feed", attachment.merge({:message => "testing facebook graphi api ...heeya!"}), options)
  end 
end

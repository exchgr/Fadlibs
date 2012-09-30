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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lib }
    end
  end

  # GET /libs/new
  # GET /libs/new.json
  def new
    @lib = Lib.new
    
    templates = ['[person1] and [person2] went to the [place].','[person1] was carrying a/an [adjective] [noun]']
    r = Random.new
    template_index = r.rand(0..templates.count-1)
    template = templates[template_index]
    logger.debug("selected template: #{template}")

    @frame_text = template.split(/\[[a-z0-9]*\]/)
    @keyword_text = template.scan(/\[[a-z0-9]*\]/)

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

  def create_lib
    if request.post?
      logger.debug("params: #{params}") 
      @lib = Lib.new
      

      @lib.update_attribute(:frame_text, params[:frame_text])
      keyword_hash = params[:form]
      keyword_array = []
      keyword_hash.each_pair { |key,value| keyword_array.append(value)}

      logger.debug("keyword array: #{keyword_array}")

      @lib.update_attribute(:keyword_text, keyword_array.join(','))

      @lib.save

      redirect_to @lib, notice: 'Lib was successfully created.'
      postStatus("I am using FabLib app at HACKNY!!")

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
    @graph.put_wall_post(message)
    #options = {}
    #attachment = {}
      #@graph.put_connections(target_id, "feed", attachment.merge({:message => "testing facebook graphi api ...heeya!"}), options)
  end 
end

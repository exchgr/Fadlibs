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

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lib }
    end
  end

  # GET /libs/1/edit
  def edit
    @lib = Lib.find(params[:id])
  end

  # POST /libs
  # POST /libs.json
  def create
    @lib = Lib.new(params[:lib])

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
end

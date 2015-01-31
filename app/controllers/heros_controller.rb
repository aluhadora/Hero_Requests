class HerosController < ApplicationController
  before_filter :set_hero, only: [:show, :edit, :update, :destroy]

  # GET /heros
  # GET /heros.json
  def index
    if (params[:stream].nil?)
      @heros = Hero.all
    else
      @stream = stream(params[:stream])
      @heros = Hero.where(stream_id: @stream.id)
    end
  end

  def herolist
    @stream = stream(params[:stream])
    @heros = Hero.where(stream_id: @stream.id)

    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    puts @heros.count
    if (@heros.count == 0)
      @list = 'There is nothing in the queue.  Add a hero like !requesthero Zeratul.'
    else
      @list = @heros.map{ |h| h.name } * ", "      
    end

    render :layout => "plaintext"
  end

  def clear
    @stream = stream(params[:stream])
    requests = Hero.where(stream_id: @stream.id)

    requests.each do |r|
      r.destroy
    end

    render :layout => "plaintext"
  end

  # GET /heros/1
  # GET /heros/1.json
  def show
    render :layout => "plaintext"
  end

  # GET /heros/new
  def new
    @hero = Hero.new
  end

  # GET /heros/1/edit
  def edit
  end

  # POST /heros
  # POST /heros.json
  def create
    @stream = stream(params[:stream])

    @hero = Hero.new
    @hero.name = params[:hero]
    @hero.stream_id = @stream.id

    respond_to do |format|
      if @hero.save
        format.html { redirect_to @hero, notice: 'Hero was successfully created.' }
        format.json { render :show, status: :created, location: @hero }
      else
        format.html { render :new }
        format.json { render json: @hero.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /heros/1
  # PATCH/PUT /heros/1.json
  def update
    respond_to do |format|
      if @hero.update(hero_params)
        format.html { redirect_to @hero, notice: 'Hero was successfully updated.' }
        format.json { render :show, status: :ok, location: @hero }
      else
        format.html { render :edit }
        format.json { render json: @hero.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /heros/1
  # DELETE /heros/1.json
  def destroy
    @hero.destroy
    respond_to do |format|
      format.html { redirect_to heros_url, notice: 'Hero was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hero
      @hero = Hero.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hero_params
      params.require(:hero).permit(:name)
    end

    def all_streams
      return Stream.all.sort!{|a,b| a.name.downcase <=> b.name.downcase }
    end

    def stream(name)
      return Stream.find(:first, :conditions => ["lower(name) = ?", name.downcase])
    end
end

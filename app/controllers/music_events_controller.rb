class MusicEventsController < ApplicationController
  before_action :set_music_event, only: [:show, :edit, :update, :destroy]

  # GET /music_events
  # GET /music_events.json
  def index
    @music_events = MusicEvent.all
  end

  # GET /music_events/1
  # GET /music_events/1.json
  def show
  end

  # GET /music_events/new
  def new
    @music_event = MusicEvent.new
  end

  # GET /music_events/1/edit
  def edit
  end

  # POST /music_events
  # POST /music_events.json
  def create
    @music_event = MusicEvent.new(music_event_params)

    respond_to do |format|
      if @music_event.save
        format.html { redirect_to @music_event, notice: 'Music event was successfully created.' }
        format.json { render :show, status: :created, location: @music_event }
      else
        format.html { render :new }
        format.json { render json: @music_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /music_events/1
  # PATCH/PUT /music_events/1.json
  def update
    respond_to do |format|
      if @music_event.update(music_event_params)
        format.html { redirect_to @music_event, notice: 'Music event was successfully updated.' }
        format.json { render :show, status: :ok, location: @music_event }
      else
        format.html { render :edit }
        format.json { render json: @music_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /music_events/1
  # DELETE /music_events/1.json
  def destroy
    @music_event.destroy
    respond_to do |format|
      format.html { redirect_to music_events_url, notice: 'Music event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_music_event
      @music_event = MusicEvent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def music_event_params
      params.require(:music_event).permit(:starts_at, :ends_at, :ticket_price, :band)
    end
end

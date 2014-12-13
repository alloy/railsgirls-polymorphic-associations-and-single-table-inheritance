class SportEventsController < ApplicationController
  before_action :set_sport_event, only: [:show, :edit, :update, :destroy]

  # GET /sport_events
  # GET /sport_events.json
  def index
    @sport_events = SportEvent.all
  end

  # GET /sport_events/1
  # GET /sport_events/1.json
  def show
  end

  # GET /sport_events/new
  def new
    @sport_event = sport_event_class.new
  end

  # GET /sport_events/1/edit
  def edit
  end

  # POST /sport_events
  # POST /sport_events.json
  def create
    @sport_event = sport_event_class.new(sport_event_params)

    respond_to do |format|
      if @sport_event.save
        format.html { redirect_to sport_event_url(@sport_event), notice: 'Sport event was successfully created.' }
        format.json { render :show, status: :created, location: @sport_event }
      else
        format.html { render :new }
        format.json { render json: @sport_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sport_events/1
  # PATCH/PUT /sport_events/1.json
  def update
    respond_to do |format|
      if @sport_event.update(sport_event_params)
        format.html { redirect_to sport_event_url(@sport_event), notice: 'Sport event was successfully updated.' }
        format.json { render :show, status: :ok, location: @sport_event }
      else
        format.html { render :edit }
        format.json { render json: @sport_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sport_events/1
  # DELETE /sport_events/1.json
  def destroy
    @sport_event.destroy
    respond_to do |format|
      format.html { redirect_to sport_events_url, notice: 'Sport event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use the appropriate SportEvent subclass.
    #
    # String#constantize turns a string like `SoccerEvent` into a class of the same name, if it exists.
    #
    def sport_event_class
      params[:sport_event][:type].constantize
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_sport_event
      @sport_event = SportEvent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sport_event_params
      params.require(:sport_event).permit(:starts_at, :ends_at, :ticket_price, :home_team, :away_team)
    end
end

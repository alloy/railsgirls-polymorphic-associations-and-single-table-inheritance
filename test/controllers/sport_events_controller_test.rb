require 'test_helper'

class SportEventsControllerTest < ActionController::TestCase
  setup do
    @sport_event = sport_events(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sport_events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sport_event" do
    assert_difference('SportEvent.count') do
      post :create, sport_event: { away_team: @sport_event.away_team, ends_at: @sport_event.ends_at, home_team: @sport_event.home_team, starts_at: @sport_event.starts_at, ticket_price: @sport_event.ticket_price }
    end

    assert_redirected_to sport_event_path(assigns(:sport_event))
  end

  test "should show sport_event" do
    get :show, id: @sport_event
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sport_event
    assert_response :success
  end

  test "should update sport_event" do
    patch :update, id: @sport_event, sport_event: { away_team: @sport_event.away_team, ends_at: @sport_event.ends_at, home_team: @sport_event.home_team, starts_at: @sport_event.starts_at, ticket_price: @sport_event.ticket_price }
    assert_redirected_to sport_event_path(assigns(:sport_event))
  end

  test "should destroy sport_event" do
    assert_difference('SportEvent.count', -1) do
      delete :destroy, id: @sport_event
    end

    assert_redirected_to sport_events_path
  end
end

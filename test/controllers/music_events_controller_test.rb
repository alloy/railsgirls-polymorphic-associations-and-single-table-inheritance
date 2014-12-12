require 'test_helper'

class MusicEventsControllerTest < ActionController::TestCase
  setup do
    @music_event = music_events(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:music_events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create music_event" do
    assert_difference('MusicEvent.count') do
      post :create, music_event: { band: @music_event.band, ends_at: @music_event.ends_at, starts_at: @music_event.starts_at, ticket_price: @music_event.ticket_price }
    end

    assert_redirected_to music_event_path(assigns(:music_event))
  end

  test "should show music_event" do
    get :show, id: @music_event
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @music_event
    assert_response :success
  end

  test "should update music_event" do
    patch :update, id: @music_event, music_event: { band: @music_event.band, ends_at: @music_event.ends_at, starts_at: @music_event.starts_at, ticket_price: @music_event.ticket_price }
    assert_redirected_to music_event_path(assigns(:music_event))
  end

  test "should destroy music_event" do
    assert_difference('MusicEvent.count', -1) do
      delete :destroy, id: @music_event
    end

    assert_redirected_to music_events_path
  end
end

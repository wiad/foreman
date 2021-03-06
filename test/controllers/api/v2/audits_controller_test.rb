require 'test_helper'

class Api::V2::AuditsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index, { }
    assert_response :success
    assert_not_nil assigns(:audits)
    audits = ActiveSupport::JSON.decode(@response.body)
    assert !audits.empty?
  end

  test "should show individual record" do
    get :show, { :id => audits(:one).to_param }
    assert_response :success
    show_response = ActiveSupport::JSON.decode(@response.body)
    assert !show_response.empty?
  end

  test 'should show audit for parent resource only' do
    host = FactoryGirl.create(:host, :managed)
    host.reload
    host.model = Model.first
    host.save!
    host.reload
    expected_audits = host.audits

    get :index, { :host_id => host.id }
    assert_response :success
    audits = ActiveSupport::JSON.decode(@response.body)
    assert_equal expected_audits.count, audits['results'].count
  end
end

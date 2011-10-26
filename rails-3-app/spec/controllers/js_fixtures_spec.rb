require 'spec_helper'

describe SomeController do
  before do
    @user = users(:user_1)
  end

  render_views

  it "generates a fixture for a user profile" do

    xhr :get, :profile, user_id: @user.id
    response.should be_success
    save_fixture(html_for('.user_profile'), 'user-profile-new')
  end
end

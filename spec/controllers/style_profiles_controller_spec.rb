require 'rails_helper'

RSpec.describe StyleProfilesController, :type => :controller do
  let(:shopper){ FactoryGirl.create(:shopper) }
  let(:other_shopper){ FactoryGirl.create(:shopper) }
  before {@request.env["devise.mapping"] = Devise.mappings[:shopper]}

  context "when shopper is not signed in" do
    context "GET edit" do
      it "redirects to signup" do
        get :edit, {id: shopper.style_profile.id}
        expect(response).to redirect_to(new_shopper_session_path)
      end
    end
  end

  context "when accessing the wrong style profile" do
    before { sign_in other_shopper }  

    context "GET edit" do
      it "redirects to root" do
        get :edit, {id: shopper.style_profile.id}
        expect(response).to redirect_to(root_path)
      end
    end
  end
end

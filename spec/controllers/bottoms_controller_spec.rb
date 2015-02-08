require 'rails_helper'

RSpec.describe BottomsController, :type => :controller do
  let(:bottom){ FactoryGirl.create(:bottom) }

  context "when unauthenticated" do
    context "GET show" do
      it "returns http success" do
        get :show, {id: bottom.id}
        expect(response).to be_success
      end
    end
  end

  context "when non-admin user is signed in" do
    let(:retail_user){ FactoryGirl.create(:retail_user) }
    before { sign_in retail_user }

    context "GET new" do
      it "redirects to signin" do
        get :new
        expect(response).to redirect_to(new_admin_session_path)
      end
    end

    context "POST create" do
      it "redirects to signin" do
        post :create, {bottom: {name: 'Foo', description: 'Bar'}}
        expect(response).to redirect_to(new_admin_session_path)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe RetailersController, :type => :controller do
  let(:retailer){ FactoryGirl.create(:retailer) }
  let(:retail_user){ FactoryGirl.create(:retail_user, retailer: retailer) }
  before {@request.env["devise.mapping"] = Devise.mappings[:retail_user]}

  context "when unauthenticated" do
    context "GET show" do
      it "returns http success" do
        get :show, {id: retailer.id}
        expect(response).to be_success
      end
    end

    context "GET index" do
      it "redirects to signin" do
        get :index
        expect(response).to redirect_to(new_admin_session_path)
      end
    end

    context "GET new" do
      it "redirects to signin" do
        get :new
        expect(response).to redirect_to(new_admin_session_path)
      end
    end

    context "POST create" do
      it "redirects to signin" do
        post :create, {retailer: {name: 'Foo', description: 'Bar'}}
        expect(response).to redirect_to(new_admin_session_path)
      end
    end

    context "GET catalog" do
      it "redirects to signin" do
        get :catalog, {id: retailer.id}
        expect(response).to redirect_to(new_retail_user_session_path)
      end
    end

    context "GET scheduler" do
      it "redirects to signin" do
        get :scheduler, {id: retailer.id}
        expect(response).to redirect_to(new_shopper_session_path)
      end
    end
  end

  context "when retail user signed in" do
    before { sign_in retail_user }

    context "GET index" do
      it "redirects to signin" do
        get :index
        expect(response).to redirect_to(new_admin_session_path)
      end
    end

    context "GET new" do
      it "redirects to signin" do
        get :new
        expect(response).to redirect_to(new_admin_session_path)
      end
    end

    context "POST create" do
      it "redirects to signin" do
        post :create, {retailer: {name: 'Foo', description: 'Bar'}}
        expect(response).to redirect_to(new_admin_session_path)
      end
    end

    context "GET catalog" do
      it "returns success" do
        get :catalog, {id: retailer.id}
        expect(response).to be_success
      end
    end
  end

  context "when wrong retail user signed in" do
    let(:wrong_user){ FactoryGirl.create(:retail_user) }
    before { sign_in wrong_user }

    context "GET catalog" do
      it "should redirect to root" do
        get :catalog, {id: retailer.id}
        expect(response).to redirect_to(root_path)
      end
    end
  end

  context "when shopper signed in" do
    let(:shopper){ FactoryGirl.create(:shopper) }
    before { sign_in shopper }

    context "GET catalog" do
      it "redirects to signin" do
        get :catalog, {id: retailer.id}
        expect(response).to redirect_to(new_retail_user_session_path)
      end
    end
  end

  context "when admin signed in" do
    let(:admin){ FactoryGirl.create(:admin) }
    before { sign_in admin }

    context "GET catalog" do
      it "returns success" do
        get :catalog, {id: retailer.id}
        expect(response).to be_success
      end
    end
  end
end

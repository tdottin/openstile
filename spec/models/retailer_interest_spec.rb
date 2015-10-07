require 'rails_helper'

RSpec.describe RetailerInterest, :type => :model do
  let(:admin){ FactoryGirl.create(:admin) }

  it { should respond_to :boutique_name }
  it { should respond_to :owner_name }
  it { should respond_to :street_address }
  it { should respond_to :city }
  it { should respond_to :state }
  it { should respond_to :zip_code }
  it { should respond_to :email }
  it { should respond_to :phone_number }
  it { should respond_to :website }
  it { should respond_to :descripton_of_boutique }

  context ""

  context "when I apply to be an openstile boutique" do
  	
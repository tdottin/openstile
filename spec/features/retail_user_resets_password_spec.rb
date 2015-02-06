require 'rails_helper'

describe "Retail user resets password" do
  describe "when I log in as a retail user" do
    let(:retail_user) { FactoryGirl.create(:retail_user, email: "john@example.com" ,
                                                   password: "barbaz",
                                                   password_confirmation: "barbaz")}
    before do
      visit root_path
      click_link 'Log in'
      click_link 'Are you a retailer?'
      fill_in 'Email', with: retail_user.email
      fill_in 'Password', with: retail_user.password
      click_button "Log in"
    end

    let(:update) { "Update" }

    it "should show me a link to reset my password" do
      expect(page).to have_link('Reset Password')
    end

    describe "and I click on the reset password link" do
      before do
        click_link "Reset Password"
      end

      it "should navigate me to the reset password page for retail users" do
        expect(page).to have_title('Retailer Password Reset | OpenStile')
        expect(page).to have_content('Reset Your Password')
      end

      describe "and I enter invalid credentials" do
        before { click_button update }

        it "takes me back to reset password page and show me an error" do
          expect(page).to have_title('Retailer Password Reset | OpenStile')
          # expect(page).to have_content("Password is too short (minimum is 6 characters)")
          # expect(page).to have_content("Current password can't be blank")
        end

      end

      describe "and I enter valid credentials" do

        it 'should allow me to edit my password' do
          fill_in 'Password', with: 'pass1234'
          fill_in 'Password confirmation', with: 'pass1234'
          fill_in 'Current password', with: 'barbaz'
          click_button update

          expect(page).to have_content('Dashboard')
          expect(page).to have_content("Your Password has been updated!")
          expect(RetailUser.to_adapter.find_first.valid_password?('pass1234')).to be_truthy
        end
      end
    end
  end
end
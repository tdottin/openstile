class Shoppers::RegistrationsController < Devise::RegistrationsController

skip_before_filter :authenticate_shopper!, :only => [:new,:create]

  # GET /resource/sign_up
  def new
    @shopper = Shopper.new
  end

  # POST /resource
  def create
    @shopper = Shopper.new(user_params)
    if @shopper.save
      sign_in(@shopper)
      redirect_to style_profiles_edit_path
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:shopper).permit(:first_name, :email, :cell_phone,
                                    :password, :password_confirmation)
  end
end

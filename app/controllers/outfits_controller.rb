class OutfitsController < ApplicationController
  before_filter :authenticate_admin!, only: [:new, :create]
  
  def show
    @outfit = Outfit.find(params[:id])
    store_recommendation_show_url
  end

  def new
    @outfit = Retailer.find(params[:retailer_id]).outfits.build
  end

  def create
    @outfit = Outfit.new(outfit_params)
    if @outfit.save
      flash[:success] = "Outfit added to catalog"
      redirect_to catalog_retailer_path(@outfit.retailer) 
    else
      render 'new'
    end
  end

  private

  def outfit_params
    params.require(:outfit).permit(:name, :description, :price_description, :average_price,
                            :retailer_id, :print_ids, :color_ids, :body_shape_id, :look_id,
                            :for_petite, :for_tall, :for_full_figured, :top_fit_id,
                            :bottom_fit_id, top_size_ids: [], bottom_size_ids: [],
                            dress_size_ids: [], special_consideration_ids: [])
  end
end

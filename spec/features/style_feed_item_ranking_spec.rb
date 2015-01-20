require 'rails_helper'

feature 'Style Feed item ranking' do
  let(:retailer){ FactoryGirl.create(:retailer) }  
  let(:top){ FactoryGirl.create(:top, retailer: retailer) }
  let(:bottom){ FactoryGirl.create(:bottom, retailer: retailer) }
  let(:dress){ FactoryGirl.create(:dress, retailer: retailer) }
  let(:shopper){ FactoryGirl.create(:shopper) }  

  scenario 'based on body shape' do
    baseline_calibration_for_shopper_and_items

    original_body_shape = FactoryGirl.create(:body_shape, name: "Hourglass")
    new_body_shape = FactoryGirl.create(:body_shape, name: "Straight")

    top.update!(body_shape_id: new_body_shape.id)
    bottom.update!(body_shape_id: original_body_shape.id)
    dress.update!(body_shape_id: FactoryGirl.create(:body_shape, name: "Apple").id)

    given_i_am_a_logged_in_shopper shopper
    when_i_set_my_style_profile_body_shape_to original_body_shape
    then_my_style_feed_should_contain top
    then_my_style_feed_should_contain bottom
    then_my_style_feed_should_contain dress
    then_the_recommendation_ordering_should_be bottom, top
    then_the_recommendation_ordering_should_be bottom, dress
    when_i_set_my_style_profile_body_shape_to new_body_shape
    then_my_style_feed_should_contain top
    then_my_style_feed_should_contain bottom
    then_my_style_feed_should_contain dress
    then_the_recommendation_ordering_should_be top, bottom
    then_the_recommendation_ordering_should_be top, dress
    then_the_recommendation_should_be_for "your Body Type"
  end

  scenario 'based on body height and build' do
    baseline_calibration_for_shopper_and_items

    original_height = "5 feet"
    new_height = "6 feet"
    original_body_build = "Average"
    new_body_build = "Full-figured"

    top.update!(for_full_figured: true)
    bottom.update!(for_petite: true)
    dress.update!(for_tall: true)

    given_i_am_a_logged_in_shopper shopper
    when_i_set_my_style_profile_height_to original_height
    when_i_set_my_style_profile_body_build_to original_body_build
    then_my_style_feed_should_contain top
    then_my_style_feed_should_contain bottom
    then_my_style_feed_should_contain dress
    then_the_recommendation_ordering_should_be bottom, top
    then_the_recommendation_ordering_should_be bottom, dress
    when_i_set_my_style_profile_height_to new_height
    when_i_set_my_style_profile_body_build_to new_body_build
    then_my_style_feed_should_contain top
    then_my_style_feed_should_contain bottom
    then_my_style_feed_should_contain dress
    then_the_recommendation_ordering_should_be top, bottom
    then_the_recommendation_ordering_should_be dress, bottom
    then_the_recommendation_should_be_for "your Body Type"
  end

  scenario 'based on favorite looks' do
    baseline_calibration_for_shopper_and_items

    original_look = FactoryGirl.create(:look, name: "Bohemian Chic")
    new_look = FactoryGirl.create(:look, name: "Glamorous")
    
    top.update!(look_id: new_look.id)
    bottom.update!(look_id: original_look.id)
    dress.update!(look_id: nil)

    given_i_am_a_logged_in_shopper shopper
    when_i_set_my_style_profile_feelings_for_a_look_as original_look, :love
    when_i_set_my_style_profile_feelings_for_a_look_as new_look, :impartial
    then_my_style_feed_should_contain top
    then_my_style_feed_should_contain bottom
    then_my_style_feed_should_contain dress
    then_the_recommendation_ordering_should_be bottom, top
    then_the_recommendation_ordering_should_be bottom, dress
    when_i_set_my_style_profile_feelings_for_a_look_as original_look, :impartial
    when_i_set_my_style_profile_feelings_for_a_look_as new_look, :love
    then_my_style_feed_should_contain top
    then_my_style_feed_should_contain bottom
    then_my_style_feed_should_contain dress
    then_the_recommendation_ordering_should_be top, bottom
    then_the_recommendation_ordering_should_be top, dress
    then_the_recommendation_should_be_for "your Favorite Looks"
  end

  scenario 'based on top fit' do
    baseline_calibration_for_shopper_and_items

    original_fit = 'Loose'
    new_fit = 'Tight/Form-Fitting'

    top.update!(top_fit: new_fit)
    dress.update!(top_fit: original_fit)

    given_i_am_a_logged_in_shopper shopper
    when_i_set_my_style_profile_preferred_fit_as original_fit, :top
    then_my_style_feed_should_contain top
    then_my_style_feed_should_contain dress
    then_the_recommendation_ordering_should_be dress, top
    when_i_set_my_style_profile_preferred_fit_as new_fit, :top
    then_my_style_feed_should_contain top
    then_my_style_feed_should_contain dress
    then_the_recommendation_ordering_should_be top, dress
    then_the_recommendation_should_be_for "your Preferred Fit"
  end

  scenario 'based on bottom fit' do
    baseline_calibration_for_shopper_and_items

    original_fit = 'Loose/Flowy'
    new_fit = 'Tight/Skinny'

    bottom.update!(bottom_fit: new_fit)
    dress.update!(bottom_fit: original_fit)

    given_i_am_a_logged_in_shopper shopper
    when_i_set_my_style_profile_preferred_fit_as original_fit, :bottom
    then_my_style_feed_should_contain bottom
    then_my_style_feed_should_contain dress
    then_the_recommendation_ordering_should_be dress, bottom
    when_i_set_my_style_profile_preferred_fit_as new_fit, :bottom
    then_my_style_feed_should_contain bottom
    then_my_style_feed_should_contain dress
    then_the_recommendation_ordering_should_be bottom, dress
    then_the_recommendation_should_be_for "your Preferred Fit"
  end

  scenario 'based on special considerations' do
    baseline_calibration_for_shopper_and_items

    original_consideration = FactoryGirl.create(:special_consideration, name:'Second-wear')
    new_consideration = FactoryGirl.create(:special_consideration, name: 'Local designers')

    top.special_considerations << new_consideration
    bottom.special_considerations << original_consideration
    dress.update!(special_consideration_ids: [])

    given_i_am_a_logged_in_shopper shopper
    when_i_set_my_style_profile_feelings_for_a_consideration_as original_consideration, :important
    when_i_set_my_style_profile_feelings_for_a_consideration_as new_consideration, :not_important
    then_my_style_feed_should_contain top
    then_my_style_feed_should_contain bottom
    then_my_style_feed_should_contain dress
    then_the_recommendation_ordering_should_be bottom, top
    then_the_recommendation_ordering_should_be bottom, dress
    then_the_recommendation_should_be_for "Second-wear"
    when_i_set_my_style_profile_feelings_for_a_consideration_as original_consideration, :not_important
    when_i_set_my_style_profile_feelings_for_a_consideration_as new_consideration, :important
    then_my_style_feed_should_contain top
    then_my_style_feed_should_contain bottom
    then_my_style_feed_should_contain dress
    then_the_recommendation_ordering_should_be top, bottom
    then_the_recommendation_ordering_should_be top, dress
    then_the_recommendation_should_be_for "Local designers"
  end

  scenario 'based on parts to show off' do
    baseline_calibration_for_shopper_and_items

    original_part = FactoryGirl.create(:part, name: "Legs")
    new_part = FactoryGirl.create(:part, name: "Midsection")

    top.exposed_parts.create!(part_id: new_part.id)
    bottom.exposed_parts.create!(part_id: original_part.id)
    dress.update!(exposed_part_ids: [])

    given_i_am_a_logged_in_shopper shopper
    when_i_set_my_style_profile_coverage_preference_as [original_part], :flaunt
    when_i_set_my_style_profile_coverage_preference_as [new_part], :impartial
    then_my_style_feed_should_contain top
    then_my_style_feed_should_contain bottom
    then_my_style_feed_should_contain dress
    then_the_recommendation_ordering_should_be bottom, top
    then_the_recommendation_ordering_should_be bottom, dress
    when_i_set_my_style_profile_coverage_preference_as [original_part], :impartial
    when_i_set_my_style_profile_coverage_preference_as [new_part], :flaunt
    then_my_style_feed_should_contain top
    then_my_style_feed_should_contain bottom
    then_my_style_feed_should_contain dress
    then_the_recommendation_ordering_should_be top, bottom
    then_the_recommendation_ordering_should_be top, dress
    then_the_recommendation_should_be_for "your Preferred Fit"
  end

  scenario 'based on favortie prints' do
    baseline_calibration_for_shopper_and_items

    original_print = FactoryGirl.create(:print, name: "Animal Print")
    new_print = FactoryGirl.create(:print, name: "Bold Patterns")

    top.update!(print_id: new_print.id)
    bottom.update!(print_id: original_print.id)
    dress.update!(print_id: nil)

    given_i_am_a_logged_in_shopper shopper
    when_i_set_my_style_profile_feelings_for_a_print_as original_print, :love
    when_i_set_my_style_profile_feelings_for_a_print_as new_print, :impartial
    then_my_style_feed_should_contain top
    then_my_style_feed_should_contain bottom
    then_my_style_feed_should_contain dress
    then_the_recommendation_ordering_should_be bottom, top
    then_the_recommendation_ordering_should_be bottom, dress
    when_i_set_my_style_profile_feelings_for_a_print_as original_print, :impartial
    when_i_set_my_style_profile_feelings_for_a_print_as new_print, :love
    then_my_style_feed_should_contain top
    then_my_style_feed_should_contain bottom
    then_my_style_feed_should_contain dress
    then_the_recommendation_ordering_should_be top, bottom
    then_the_recommendation_ordering_should_be top, dress
    then_the_recommendation_should_be_for "your Preferred Prints and Patterns"
  end

  private
    def baseline_calibration_for_shopper_and_items
      shared_top_size = FactoryGirl.create(:top_size)
      shared_bottom_size = FactoryGirl.create(:bottom_size)
      shared_dress_size = FactoryGirl.create(:dress_size)

      shopper.style_profile.top_sizes << shared_top_size
      top.top_sizes << shared_top_size
      shopper.style_profile.bottom_sizes << shared_bottom_size
      bottom.bottom_sizes << shared_bottom_size
      shopper.style_profile.dress_sizes << shared_dress_size
      dress.dress_sizes << shared_dress_size

      shopper.style_profile.budget.update!(top_min_price: 50.00, top_max_price: 100.00,
                                     bottom_min_price: 50.00, bottom_max_price: 100.00,
                                     dress_min_price: 50.00, dress_max_price: 100.00)

      top.update!(price: 75.00)
      bottom.update!(price: 75.00)
      dress.update!(price: 75.00)
    end
end
require 'rails_helper'
require_relative '../support/ui_helper.rb'

RSpec.feature "UI_fixes", type: :feature, js: true do
  include_context "db_cleanup"
  include UiHelper


  describe "Welcome" do
    it "shows the text" do
      visit "#{ui_path}/#/welcome"
      expect(page).to have_content("Welcome")
      expect(page).to have_content("This is fullstack challenge from Devolute.")
    end
  end


  describe "Images" do
    it "shows the text" do
      visit "#{ui_path}/#/images/"
      expect(page).to have_content("Log in to see the list of images.")
      expect(page).to have_no_css(".image-list")
    end

   context "logged in" do

    let(:user) { create_user }

    it "shows the list and hides the text" do
      visit "#{ui_path}/#/images/"
      login user
      expect(page).to have_css(".image-list")
      expect(page).to have_no_content("Log in to see the list of images.")
    end
   end
  end


  describe "Sign Up" do
    it "shows the form" do
      visit "#{ui_path}/#/signup/"
      expect(page).to have_css("#signup-form")
      expect(page).to have_no_content("It seems you are already logged in!")
    end

   context "logged in" do

    let(:user) { create_user }

    it "shows the text" do
      visit "#{ui_path}/#/signup/"
      login user
      expect(page).to have_content("It seems you are already logged in!")
      expect(page).to have_no_css("#signup-form")
    end
   end
  end

end

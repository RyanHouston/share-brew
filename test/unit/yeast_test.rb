require 'test_helper'

class YeastTest < ActiveSupport::TestCase
  context "a yeast strain" do

    setup do
      @yeast = Factory(:yeast)
    end 

    [:strain, :catalog_id, :vendor, :form].each do |value|
      should validate_presence_of value
    end

    ## SKIP - should work but shoulda is not filling other required fields
    # should validate_uniqueness_of(:catalog_id).scoped_to(:vendor)
    %w(dry liquid).each do |value|
      should allow_value(value).for(:form)
    end
    %w(slant 1).each do |value|
      should_not allow_value(value).for(:form)
    end
  end

  context "The Yeast class" do
    should "act as a beer importer" do
      assert_respond_to Yeast, :acts_as_beer_importer_of
      assert_respond_to Yeast, :import_beer_xml
    end

    should "be able to import a beer xml file of yeasts" do
      yeasts = Yeast.import_beer_xml load_file
      yeast = yeasts.first
      assert_instance_of Yeast, yeast
      assert_equal "American Megabrewery", yeast.strain
      assert_equal "Brewtek", yeast.vendor
      assert_equal "CL-0620", yeast.catalog_id
      assert_equal 8.8889, yeast.min_temp
      assert_equal 14.4444 , yeast.max_temp
      assert_equal 73.00, yeast.attenuation
      # TODO assert_equal 'Medium', yeast.flocculation
    end
  end

  def load_file
    file = Rails.root + 'test/fixtures/yeast.xml'
  end

end

require 'spec_helper'
require 'malt_bill'

describe MaltBill do
  def build_fermentable_addition(weight, potential)
    fermentable = FactoryGirl.build(:fermentable, potential: potential)
    fermentable_addition = FermentableAddition.new(weight: weight)
    fermentable_addition.fermentable = fermentable

    fermentable_addition
  end

  subject do
    fermentables = [
      build_fermentable_addition(10, 1.038),
      build_fermentable_addition(2, 1.026)
    ]

    MaltBill.new(
      fermentables: fermentables,
      batch_size: 5.5,
      mash_efficiency: 0.68
    )
  end

  its (:batch_size) { should eq 5.5 }
  its (:mash_efficiency) { should eq 0.68 }

  describe "#fermentable_gravity_units" do
    before (:each) do
      @fermentable_addition = FermentableAddition.new
      @fermentable_addition.weight = 10
      @fermentable_addition.fermentable = FactoryGirl.build(
        :fermentable, potential: 1.038)
    end

    its (:mash_efficiency)  { should == 0.68 }

    # 10 lbs * 38 GUs * 0.68 mash efficiency
    it "calculates gravity units in relation to the recipe" do
      gravity_units = subject.fermentable_gravity_units(@fermentable_addition)
      sprintf('%5.2f', gravity_units).should == "258.40"
    end

    it "calculates the total gravity units of the malt bill" do
      gravity_units = subject.total_gravity_units
      sprintf('%5.2f', gravity_units).should ==  "293.76"
    end

    it "calculates the starting gravity of the total malt bill" do
      starting_gravity = subject.starting_gravity
      sprintf('%5.3f', starting_gravity).should == "1.053"
    end
  end
end


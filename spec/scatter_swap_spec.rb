require 'spec_helper'

describe "#hash" do
  it "should be 10 digits" do
    100.times do |integer|
      ScatterSwap.hash(integer).to_s.length.should == 10
    end
  end

  it "should not be sequential" do
    first = ScatterSwap.hash(1)
    second = ScatterSwap.hash(2)
    second.should_not eql(first.to_i + 1)
  end

  it "should be reversable" do
    100.times do |integer|
      hashed = ScatterSwap.hash(integer)
      ScatterSwap.reverse_hash(hashed).to_i.should == integer
    end
  end
end

describe "#swapper_map" do
  before do
    @map_set = []
    10.times do |digit|
      @map_set.push ScatterSwap.swapper_map(digit)
    end
  end

  it "should create a unique map array for each digit" do
    @map_set.length.should == 10
    @map_set.uniq.length.should == 10
  end

  it "should include all 10 digits in each map" do
    @map_set.each do |map|
      map.length.should == 10
      map.uniq.length.should == 10
    end
  end
end

describe "#scatter" do
  it "should return a number different from original" do
    100.times do |integer|
      array = ScatterSwap.arrayify(integer)
      ScatterSwap.scatter(array).should_not == integer
    end
  end
  it "should be reversable" do
    100.times do |integer|
      original = ScatterSwap.arrayify(integer)
      scattered = ScatterSwap.scatter(original.clone)
      ScatterSwap.unscatter(scattered).should == original
    end
  end
end

describe "#swap" do
  it "should be different from original" do
    100.times do |integer|
      original = ScatterSwap.arrayify(integer)
      ScatterSwap.swap(original.clone).should_not == original
    end
  end
  it "should be reversable" do
    100.times do |integer|
      original = ScatterSwap.arrayify(integer)
      swapped = ScatterSwap.swap(original.clone)
      ScatterSwap.unswap(swapped.clone).should == original
    end
  end
end  

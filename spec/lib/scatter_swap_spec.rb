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
    s = ScatterSwap.new(1)
    10.times do |digit|
      @map_set.push s.swapper_map(digit)
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
      s = ScatterSwap.new(integer)
      original_array = s.working_array
      s.scatter
      s.working_array.should_not == original_array
    end
  end
  it "should be reversable" do
    100.times do |integer|
      s = ScatterSwap.new(integer)
      original_array = s.working_array.clone
      s.scatter
      s.unscatter
      s.working_array.should == original_array
    end
  end
end

describe "#swap" do
  it "should be different from original" do
    100.times do |integer|
      s = ScatterSwap.new(integer)
      original_array = s.working_array.clone
      s.swap
      s.working_array.should_not == original_array
    end
  end
  it "should be reversable" do
    100.times do |integer|
      s = ScatterSwap.new(integer)
      original_array = s.working_array.clone
      s.swap
      s.unswap
      s.working_array.should == original_array
    end
  end
end  

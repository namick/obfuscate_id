require 'spec_helper'


describe "#obfuscate_id_spin" do
  context "when spin defined" do
    before do
      class User < ActiveRecord::Base
        obfuscate_id spin: 987654321
      end

      class Post < ActiveRecord::Base
        obfuscate_id spin: 123456789
      end
    end
    
    it "should return correct value" do
      User.obfuscate_id_spin.should == 987654321
      Post.obfuscate_id_spin.should == 123456789
    end

    it "uses the spin given" do
      u = User.new(id: 1)
      p = Post.new(id: 1)
      u.to_param.should_not == p.to_param
    end
  end

  context "when not defined" do
    before do
      class User < ActiveRecord::Base
        obfuscate_id
      end

      class Post < ActiveRecord::Base
        obfuscate_id
      end
    end

    it "should return a unique value computed from model name" do
      User.obfuscate_id_spin.should_not == Post.obfuscate_id_spin
    end

    it "uses computed spin" do
      u = User.new(id: 1)
      p = Post.new(id: 1)
      u.to_param.should_not == p.to_param
    end
  end

end


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
    
    it "reports correct value" do
      expect(User.obfuscate_id_spin).to eql 987654321
      expect(Post.obfuscate_id_spin).to eql 123456789
    end

    it "uses the spin given" do
      u = User.new(id: 1)
      p = Post.new(id: 1)
      expect(u.to_param).to_not eql p.to_param
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

    it "reports a unique value computed from model name" do
      expect(User.obfuscate_id_spin).to_not eql Post.obfuscate_id_spin
    end

    it "uses computed spin" do
      u = User.new(id: 1)
      p = Post.new(id: 1)
      expect(u.to_param).to_not eql p.to_param
    end

    describe "for model with long name" do
      before do
        class ModelWithVeryLongName < ActiveRecord::Base
          obfuscate_id
        end
      end
        it 'compute default spin correctly' do
          rec = ModelWithVeryLongName.new(id: 1)
          expect(rec.to_param).to_not raise_error(/bignum too big/)
        end
    end

  end
end

describe "#deobfuscate_id" do
  before do
    class User < ActiveRecord::Base
      obfuscate_id
    end
  end

  let (:user) { User.create(id: 1) }

  subject {User.deobfuscate_id(user.to_param).to_i}
  it "should reverse the obfuscated id" do
    should eq(user.id)
  end
end


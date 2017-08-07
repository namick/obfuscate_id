require 'spec_helper'

describe ObfuscateId do
  describe "#obfuscate_id_spin" do
    let(:user) { User.new(id: 1) }
    let(:post) { Post.new(id: 1) }

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
        expect(user.to_param).to_not eql post.to_param
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
        expect(user.to_param).to_not eql post.to_param
      end

      describe "for model with long name" do
        before do
          class SomeReallyAbsurdlyLongNamedClassThatYouWouldntHaveThoughtOfs < ActiveRecord::Base
            def self.columns() @columns ||= []; end

            def self.column(name, sql_type = nil, default = nil, null = true)
              columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
            end

            obfuscate_id
          end
        end

        it 'compute default spin correctly' do
          rec = SomeReallyAbsurdlyLongNamedClassThatYouWouldntHaveThoughtOfs.new(id: 1)
          expect { rec.to_param }.not_to raise_error
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

    let(:user) { User.create(id: 1) }

    subject(:deobfuscated_id) { User.deobfuscate_id(user.to_param).to_i }

    it "reverses the obfuscated id" do
      should eq(user.id)
    end
  end
end

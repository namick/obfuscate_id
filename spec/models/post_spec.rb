require 'spec_helper'

describe Post do
  describe "Reloading a record" do
    subject(:post) { Post.create(content: "original") }

    it "does not throw an error" do
      expect(lambda { post.reload }).to_not raise_error
    end

    it "reloads correctly" do
      post = Post.find(subject.to_param)
      post.update_attribute :content, "new"

      expect(subject.content).to eql "original"

      subject.reload

      expect(subject.content).to eql "new"
    end

    it "resets id to original value" do
      id = subject.id
      param = subject.to_param
      subject.reload

      expect(subject.id).to eql id
      expect(subject.to_param).to eql param
    end
  end

  describe "Finding multiple records" do
    let (:post1) { Post.create content: "one" }
    let (:post2) { Post.create content: "two" }
    subject {Post.find([post1.to_param, post2.to_param])}

    it "should load all items" do
      should eq([post1, post2])
    end
  end

  context 'When not persisted yet' do
    let (:new_post) { Post.new content: "one" }

    it 'has no param' do
      expect(new_post.to_param).to be_nil
    end
  end
end

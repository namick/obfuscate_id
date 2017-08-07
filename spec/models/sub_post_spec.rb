require 'spec_helper'

describe Post::SubPost do
  describe "Reloading a record" do
    subject(:post) { Post::SubPost.create(content: "original") }

    it "does not throw an error" do
      expect(lambda { post.reload }).to_not raise_error
    end

    it "reloads correctly" do
      post = Post::SubPost.find(subject.to_param)
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
    let (:post1) { Post::SubPost.create content: "one" }
    let (:post2) { Post::SubPost.create content: "two" }
    subject {Post::SubPost.find([post1.to_param, post2.to_param])}

    it "should load all items" do
      should eq([post1, post2])
    end
  end
end

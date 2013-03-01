require 'spec_helper'

describe "Reloading a record" do
  subject { Post.create content: "original" }

  it "does not throw an error" do
    lambda { subject.reload }.should_not raise_error
  end

  it "reloads correctly" do
    post = Post.find(subject.to_param)
    post.update_attribute :content, "new"
    subject.content.should == "original"
    subject.reload
    subject.content.should == "new"
  end

  it "resets id to original value" do
    id = subject.id
    param = subject.to_param
    subject.reload
    subject.id.should == id
    subject.to_param.should == param
  end
end

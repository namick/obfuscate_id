require 'spec_helper'

describe "Reloading a record" do
  subject { Post.create content: "original" }

  it "does not throw an error" do
    expect(lambda { subject.reload }).to_not raise_error
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

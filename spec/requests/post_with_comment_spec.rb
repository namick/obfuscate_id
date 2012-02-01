require 'spec_helper'

describe "Post" do
  before do
    visit new_post_path
    fill_in "Content", :with => "First post"
    click_on "Create Post"
    visit posts_path
    click_on "First post"
  end

  it "should have obfuscated id via url helpers" do
    page.should_not have_content('post_path: "/posts/1"')
  end

  it "should still have plain id attibute" do
    page.should have_content("ID: 1")
  end

end


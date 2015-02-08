require 'spec_helper'

describe "Models with and without ObfuscateId" do
  before do
    visit new_post_path
    fill_in "post_content", :with => "First post"
    click_on "Create Post"
    visit posts_path
    click_on "First post"
    fill_in "comment_content", :with => "First comment"
    click_on "Create Comment"
  end

  describe "Post (using ObfuscateId)" do
    it "has plain id attibute" do
      expect(page).to have_content("post.id: 1")
    end

    it "has obfuscated id via url helpers" do
      expect(page).to_not have_content('post_path: /posts/1.')
    end
  end

  describe "Comment (not using ObfuscateId)" do
    it "has plain id attribute" do
      expect(page).to have_content("comment.id: 1")
    end

    it "has plain id via url helpers" do
      expect(page).to have_content('comment_path: /comments/1.')
    end
  end

end


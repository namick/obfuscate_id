require 'spec_helper'

describe "Models with and without ObfuscateId" do
  subject { page }

  before do
    class Post < ActiveRecord::Base
      has_many :comments
      obfuscate_id spin: 123456789
    end

    class Comment < ActiveRecord::Base
      belongs_to :post
    end

    visit new_post_path
    fill_in "post_content", :with => "First Post"
    click_on "Create Post"

    visit posts_path
    click_on "First Post"

    within "form.new_comment" do
      fill_in "comment_content", :with => "First Comment"
    end
    click_on "Create Comment"
  end

  describe "Post (using ObfuscateId)" do
    it "has plain id attibute" do
      should have_content("post: First Post")
      should have_content("post.id: 1")
      should have_content("post.to_param: r7")
      should have_content('post_path: /posts/r7.')
    end
  end

  describe "Comment (not using ObfuscateId)" do
    it "has plain id attribute" do
      should have_content("comment: First Comment")
      should have_content("comment.id: 1")
      should have_content("comment.to_param: 1")
      should have_content('comment_path: /comments/1.')
    end
  end

  describe "Post and Comment using obfuscate_id with different spins" do
    before do
      class Post < ActiveRecord::Base
        has_many :comments
        obfuscate_id spin: 123456789
      end

      class Comment < ActiveRecord::Base
        belongs_to :post
        obfuscate_id spin: 987654321
      end

      click_on "Edit Post"
      fill_in "post_content", with: "Updated first post"
      click_on "Update Post"

      within "form.edit_comment" do
        fill_in "comment_content", with: "Updated first comment"
      end
      click_on "Update Comment"
    end

    it "Post is updated and has obfuscated_id" do
      should have_content("post: Updated first post")
      should have_content("post.id: 1")
      should have_content("post.to_param: r7")
      should have_content("post_path: /posts/r7")
    end

    it "Comment is updated and has obfuscated_id" do
      should have_content("comment: Updated first comment")
      should have_content("comment.id: 1")
      should have_content("comment.to_param: yl")
      should have_content("comment_path: /comments/yl")
    end
  end
end

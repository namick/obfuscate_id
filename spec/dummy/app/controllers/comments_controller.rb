class CommentsController < ApplicationController

  def create
    @comment = Comment.create! params[:comment]
    redirect_to post_path(@comment.post)
  end
end

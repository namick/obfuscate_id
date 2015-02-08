class CommentsController < ApplicationController

  def create
    @comment = Comment.create! comment_params
    redirect_to post_path(@comment.post)
  end

  private
  
  def comment_params
    params.require(:comment).permit(:post_id, :content)
  end
end

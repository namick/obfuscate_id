class CommentsController < ApplicationController

  def create
    @comment = Comment.create! comment_params
    redirect_to post_path(@comment.post)
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      redirect_to @comment.post
    else
      render :edit
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:id, :content, :post_id)
  end
end

class CommentsController < ApplicationController
  before_action :load_comment, except: [:new, :create]
  before_action :comment_params, only: [:update, :create]

  def create
    @comment = Comment.create comment_params
    render 'create.js', locals: {comment: @comment, item: @comment.item}
  end

  def show
    @like = current_user.likes.find_or_initialize_by(likable_id: @comment)
	  @like.destroy unless @like.new_record?
  end

  def edit
    render 'edit.js', locals: {comment: @comment, item: @comment.item}
  end

  def update
    @comment.update comment_params
    render 'update.js', locals: {comment: @comment, item: @comment.item}
  end

  def destroy
    @comment.destroy
    render 'destroy.js', locals: {comment: @comment, item: @comment.item}
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :user_id, :item_id)
  end

  def load_comment
    @comment = Item.find_by(id: params[:item_id]).comments.find_by(id: params[:id])
  end

end

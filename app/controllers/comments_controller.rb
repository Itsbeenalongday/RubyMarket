class CommentsController < ApplicationController
  before_action :load_comment, except: [:new, :create]
  before_action :comment_params, only: [:update, :create]

  def create
    @comment = Comment.create comment_params
    render 'create.js', locals: {comment: @comment, item: @comment.item}
  end

  def show
    @comment_like = current_user.likes.find_or_initialize_by(likable_id: @comment.id, likable_type: "Comment")
    @comment_like.new_record? ? @comment_like.save : @comment_like.destroy
    render 'comments/likable.js', locals: { like: @comment_like.destroyed? ? true : false }
  end

  def edit
    render 'edit.js', locals: {comment: @comment, item: @comment.item}
  end

  def update
    # 댓글을 페이지 네이션하려면 댓글하나가 아닌 댓글들의 컨테이너를 교체, or paginate remote:true옵션
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

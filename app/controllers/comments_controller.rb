class CommentsController < ApplicationController
    def create
        post = Post.find(params[:post_id])
        @comment = post.comments.build(comment_params)
        @comment.user_id = current_user.id
        if @comment.save
            flash[:notice] = "コメントしました"
            redirect_back(fallback_location: root_path)
        else
            flash[:notice] = "コメントできませんでした"
            redirect_back(fallback_location: root_path)
        end
    end

    private

    def comment_params
        params.require(:comment).permit(:content)
    end
end

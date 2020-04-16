class RelationshipsController < ApplicationController

    def create
        following = current_user.follow(user)
        if following.save
            redirect_to user, notice: "ユーザーをフォローしました"
        else
            redirect_to user, alert: "ユーザーのフォローに失敗しました"
        end
    end

    def destroy
        following = current_user.unfollow(user)
        if following.destroy
            redirect_to user, notice: "ユーザーのフォローを解除しました"
        else
            redirect_to user, alerts: "ユーザーのフォロー解除に失敗しました"
        end
    end

    private

    def user
        @user = User.find(params[:relationship][:follow_id])
    end
end

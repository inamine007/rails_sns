class User < ApplicationRecord
    has_secure_password
    has_one_attached :image
    has_many :posts
    has_many :comments
    has_many :relationships
    has_many :followings, through: :relationships, source: :follow
    has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
    has_many :followers, through: :reverse_of_relationships, source: :user
    has_many :likes, dependent: :destroy
    has_many :liked_posts, through: :likes, source: :post
    validates :name, presence: true
    validates :mail, presence: true, uniqueness: true

    def follow(other_user)
        unless self == other_user
            self.relationships.find_or_create_by(follow_id: other_user.id)
        end
    end

    def unfollow(other_user)
        relationship = self.relationships.find_by(follow_id: other_user.id)
        relationship.destroy if relationship
    end

    def following?(other_user)
        self.followings.include?(other_user)
    end

    def already_liked?(post)
        self.likes.exists?(post_id: post.id)
    end
end

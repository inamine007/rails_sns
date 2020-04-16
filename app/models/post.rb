class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_one_attached :image
  has_many :likes
  has_many :liked_users, through: :likes, source: :user
  def self.ransackable_attributes(auth_object = nil)
    %w[title]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  validates :title, presence: true
  validates :content, presence: true, length: { maximum: 150 }
end

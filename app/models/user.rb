class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy

  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # relationships=follower_idが同じのものをとってくるので、フォローされた人のidの集まりである
  has_many :followings, through: :relationships, source: :followed
  # followings=その人がフォローした人たち(followed_id)を探してきている

  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # reverse_of_relationships=followed_idが同じものをとってくるので、その人をフォローした人のidの集まりである
  has_many :followers, through: :reverse_of_relationships, source: :follower
  # followers=その人をフォローした人たち(follower_id)を探してきている

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50 }

  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def self.search_for(content,method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE?',content + '%')
    elsif method == "backward_match"
      User.where('name LIKE?','%' + content)
    else
      User.where('name LIKE?','%' + content + '%')
    end
  end
end

class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search_for(content,method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('title LIKE?',content+'%')
    elsif method == "backward_match"
      Book.where('title LIKE?','%'+content)
    else
      Book.where('title LIKE?','%'+content+'%')
    end
  end

def day_count
  @post_count = Book.group('DAY(created_at)').count
end

def week_count
  @post_count = Book.group('WEEK(created_at)').count
end

end

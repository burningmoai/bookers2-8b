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

# scope機能 モデル側であらかじめ特定の条件式に対して名前をつけて定義
# →メソッドを呼び出すように条件式を呼び出すことができる
# scope:スコープ名,->{条件式}
# 投稿数を表示する準備
scope :created_today, -> {where(created_at: Time.current.all_day)} #今日
scope :created_yesterday, -> {where(created_at: 1.day.ago.all_day)} #前日
scope :created_this_week, -> {where(created_at: 6.day.ago.beginning_of_day..Time.current.end_of_day)} #今週
scope :created_last_week, -> {where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day)} #前週
end

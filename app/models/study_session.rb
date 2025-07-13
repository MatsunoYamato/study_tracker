# == Schema Information
#
# Table name: study_sessions
#
#  id         :bigint           not null, primary key
#  duration   :integer
#  note       :text
#  studied_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_study_sessions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class StudySession < ApplicationRecord
  belongs_to :user

  has_many :study_session_tags, dependent: :destroy
  has_many :tags, through: :study_session_tags

  # バリデーション
  validates :duration, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 720 } # 最大12時間
  validates :studied_at, presence: true
  validates :note, length: { maximum: 1000 }

  # スコープ（よく使う検索条件）

  scope :recent, -> { order(studied_at: :desc) }
  scope :today, -> { where(studied_at: Date.current.all_day) }
  scope :this_week, -> { where(studied_at: 1.week.ago..Time.current) }

  # メソッド
  def duration_in_hours
    duration / 60.0
  end

  # 表示用の学習時間フォーマット
  def formatted_duration
    if duration < 60
      "#{duration}分"
    else
      hours = duration / 60
      minutes = duration % 60
      if minutes == 0
        "#{hours}時間"
      else
        "#{hours}時間#{minutes}分"
      end
    end
  end
end

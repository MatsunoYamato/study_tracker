# == Schema Information
#
# Table name: tags
#
#  id          :bigint           not null, primary key
#  color       :string
#  description :text
#  is_preset   :boolean
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Tag < ApplicationRecord
  has_many :study_session_tags, dependent: :destroy
  has_many :study_sessions, through: :study_session_tags
  has_many :users, through: :study_sessions
  
  # バリデーション
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :color, presence: true, format: { with: /\A#[0-9A-Fa-f]{6}\z/ }
  validates :description, length: { maximum: 500 }
  
  # スコープ
  scope :preset, -> { where(is_preset: true) }
  scope :user_created, -> { where(is_preset: false) }
  scope :popular, -> { joins(:study_sessions).group(:id).order('COUNT(study_sessions.id) DESC') }
  
  # デフォルト値設定
  before_validation :set_defaults
  
  private
  
  def set_defaults
    self.is_preset ||= false
    self.color ||= '#6B7280' if color.blank?
  end
end

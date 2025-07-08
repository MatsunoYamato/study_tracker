# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  profile_image          :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :study_sessions, dependent: :destroy
  has_many :study_session_tags, through: :study_sessions
  has_many :tags, through: :study_session_tags
  
  # プロフィール画像
  has_one_attached :avatar
  
  validates :email, presence: true, uniqueness: true
  validate :avatar_size_validation, if: -> { avatar.attached? }
  validate :avatar_content_type_validation, if: -> { avatar.attached? }

  private

  def avatar_size_validation
    if avatar.blob.byte_size > 2.megabytes
      errors.add(:avatar, 'のファイルサイズは2MB以下にしてください')
    end
  end

  def avatar_content_type_validation
    unless avatar.blob.content_type.in?(['image/jpeg', 'image/png', 'image/gif'])
      errors.add(:avatar, 'はJPEG、PNG、GIF形式のファイルをアップロードしてください')
    end
  end
end

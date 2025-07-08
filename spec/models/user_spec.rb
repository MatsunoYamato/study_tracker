# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
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
require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it "有効なファクトリを持つ" do
      user = build(:user)
      expect(user).to be_valid
    end
    
    it "メールアドレスが必須" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end
    
    it "重複したメールアドレスは無効" do
      create(:user, email: "test@example.com")
      user = build(:user, email: "test@example.com")
      expect(user).not_to be_valid
    end
  end
  
  describe "関連付け" do
    it "学習記録を持つ" do
      user = create(:user)
      study_session = create(:study_session, user: user)
      
      expect(user.study_sessions).to include(study_session)
    end
    
    it "ユーザー削除時に学習記録も削除される" do
      user = create(:user)
      create(:study_session, user: user)
      
      expect { user.destroy }.to change(StudySession, :count).by(-1)
    end
  end
end

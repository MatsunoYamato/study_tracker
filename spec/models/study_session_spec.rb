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
require 'rails_helper'

RSpec.describe StudySession, type: :model do
  describe 'バリデーション' do
    it '有効なファクトリを持つ' do
      study_session = build(:study_session)
      expect(study_session).to be_valid
    end

    it '学習時間が必須' do
      study_session = build(:study_session, duration: nil)
      expect(study_session).not_to be_valid
    end

    it '学習時間は正の数である必要がある' do
      study_session = build(:study_session, duration: 0)
      expect(study_session).not_to be_valid

      study_session = build(:study_session, duration: -10)
      expect(study_session).not_to be_valid
    end

    it '学習時間は720分（12時間）以下である必要がある' do
      study_session = build(:study_session, duration: 721)
      expect(study_session).not_to be_valid
    end
  end

  describe 'スコープ' do
    let(:user) { create(:user) }

    it 'recent で新しい順に並ぶ' do
      create(:study_session, user: user, studied_at: 2.days.ago)
      new_session = create(:study_session, user: user, studied_at: 1.day.ago)

      expect(StudySession.recent.first).to eq(new_session)
    end

    it 'today で今日の記録のみ取得' do
      today_session = create(:study_session, :today, user: user)
      yesterday_session = create(:study_session, user: user, studied_at: 1.day.ago)

      expect(StudySession.today).to include(today_session)
      expect(StudySession.today).not_to include(yesterday_session)
    end
  end

  describe 'インスタンスメソッド' do
    it 'duration_in_hours で時間を時間単位で返す' do
      study_session = create(:study_session, duration: 90)
      expect(study_session.duration_in_hours).to eq(1.5)
    end
  end
end

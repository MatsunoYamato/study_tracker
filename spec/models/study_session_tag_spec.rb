# == Schema Information
#
# Table name: study_session_tags
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  study_session_id :bigint           not null
#  tag_id           :bigint           not null
#
# Indexes
#
#  index_study_session_tags_on_study_session_id  (study_session_id)
#  index_study_session_tags_on_tag_id            (tag_id)
#
# Foreign Keys
#
#  fk_rails_...  (study_session_id => study_sessions.id)
#  fk_rails_...  (tag_id => tags.id)
#
# spec/models/study_session_tag_spec.rb
require 'rails_helper'

RSpec.describe StudySessionTag, type: :model do
  describe 'バリデーション' do
    it '有効なファクトリを持つ' do
      study_session_tag = build(:study_session_tag)
      expect(study_session_tag).to be_valid
    end

    it '同じ学習記録に同じタグは重複できない' do
      study_session = create(:study_session)
      tag = create(:tag)

      create(:study_session_tag, study_session: study_session, tag: tag)
      duplicate = build(:study_session_tag, study_session: study_session, tag: tag)

      expect(duplicate).not_to be_valid
    end
  end

  describe '関連付け' do
    it '学習記録に属する' do
      study_session_tag = create(:study_session_tag)
      expect(study_session_tag.study_session).to be_present
    end

    it 'タグに属する' do
      study_session_tag = create(:study_session_tag)
      expect(study_session_tag.tag).to be_present
    end
  end
end

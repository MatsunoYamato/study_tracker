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
class StudySessionTag < ApplicationRecord
  belongs_to :study_session
  belongs_to :tag

    # 重複防止
  validates :study_session_id, uniqueness: { scope: :tag_id }
end

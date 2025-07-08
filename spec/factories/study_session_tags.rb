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
FactoryBot.define do
  factory :study_session_tag do
    study_session { nil }
    tag { nil }
  end
end

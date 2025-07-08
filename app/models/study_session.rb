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
end

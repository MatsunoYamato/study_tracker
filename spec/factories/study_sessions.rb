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
FactoryBot.define do
  factory :study_session do
    user
    duration { rand(15..180) } # 15分〜3時間のランダム
    studied_at { Faker::Time.between(from: 1.week.ago, to: Time.current) }
    note { Faker::Lorem.paragraph }

    # 今日の学習記録
    trait :today do
      studied_at { Time.current }
    end

    # ポモドーロセッション（25分）
    trait :pomodoro do
      duration { 25 }
      note { 'ポモドーロで集中学習' }
    end

    # タグ付きの学習記録
    trait :with_tags do
      after(:create) do |study_session|
        tags = create_list(:tag, 2, name: "Tag#{rand(1000)}")
        tags.each do |tag|
          create(:study_session_tag, study_session: study_session, tag: tag)
        end
      end
    end
  end
end

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
FactoryBot.define do
  factory :tag do
    name { Faker::ProgrammingLanguage.name }
    description { Faker::Lorem.sentence }
    color { "##{Faker::Color.hex_color.delete('#').upcase}" }
    is_preset { false }
    
    trait :preset do
      is_preset { true }
      name { "Ruby" }
      color { "#CC342D" }
    end
  end
end

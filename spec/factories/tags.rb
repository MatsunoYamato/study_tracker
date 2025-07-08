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
    name { "MyString" }
    description { "MyText" }
    color { "MyString" }
    is_preset { false }
  end
end

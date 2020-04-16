FactoryBot.define do
  factory :post do
    title { "MyString" }
    content { "MyText" }
    image { "MyString" }
    user { nil }
  end
end

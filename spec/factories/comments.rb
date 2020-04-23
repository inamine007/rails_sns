FactoryBot.define do
  factory :comment do
    content { "テストコメント" }
    user
    post
  end
end

FactoryBot.define do
  factory :user do
    name { "テストユーザー" }
    mail { "test1@example.com" }
    image { Rack::Test::UploadedFile.new Rails.root.join('spec/files/test.png'), 'image/png' }
    password { "password" }
    birthday { "4/16" }
    introduce { "よろしくお願いします" }
  end
end

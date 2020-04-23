FactoryBot.define do
  factory :post do
    title { "テストを書く" }
    content { "RSpec ＆ Capybara ＆ FactoryBotを準備する" }
    image { Rack::Test::UploadedFile.new Rails.root.join('spec/files/test.png'), 'image/png' }
    user
  end
end

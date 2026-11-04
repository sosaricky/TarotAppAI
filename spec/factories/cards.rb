FactoryBot.define do
  factory :card do
    sequence(:name) { |n| "The Fool #{n}" }
    message { "A test message" }
    image_path { "images/cards/the_fool.jpg" }
  end
end

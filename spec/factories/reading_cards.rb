FactoryBot.define do
  factory :reading_card do
    reading
    card
    position { 0 }
    reversed { false }
    message { "A sample message" }
  end
end

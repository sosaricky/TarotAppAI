FactoryBot.define do
  factory :reading do
    name { "Test reading" }
    conclusion { "A test conclusion" }
    user
  end
end

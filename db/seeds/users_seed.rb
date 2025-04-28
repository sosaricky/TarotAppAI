default_passowrd = 'wdk45pepetyn'

5.times do
  user = User.find_or_create_by(email: Faker::Internet.unique.email) do
    |new_user|
    new_user.password = default_passowrd
  end
  puts "Usuario creado: #{user.email}"
end

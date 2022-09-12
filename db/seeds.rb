# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
User.create!(name: "root", email: "root@email.com",
             password: "root1234", password_confirmation: "root1234",
             admin: true, activated: true, activated_at: Time.zone.now)

99.times do |n|
  name = Faker::Name.name
  email = "#{name.split(" ")[0]}_0#{n}@gmail.com"
  password = "password"

  user_data = { name: name, email: email, password: password, password_confirmation: password,
                activated: true, activated_at: Time.zone.now }

  User.create!(user_data)
end

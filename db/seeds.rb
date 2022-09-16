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

users = User.order(:created_at).take(5)
50.times do |n|
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.posts.create!(content: content) }
end

#Following relations
users = User.all
user_a = users.first

following = users[2..30]
followed = users[10..40]

following.each { |followed| user_a.follow(followed) }
followed.each { |follower| follower.follow(user_a) }

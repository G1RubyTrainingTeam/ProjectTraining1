User.create!(
  name: "admin",
  email: "admin@gmail.com",
  password: "123456",
  role: "admin",
  avatar: nil
)

User.create!(
  name: "pham anh tuan",
  email: "tuan@gmail.com",
  password: "123456",
  role: "lecture",
  avatar: nil
)

5.times do |i|
  User.create!(
    name: "User #{i}",
    email: "user#{i}@gmail.com",
    password: "123456",
    role: "student",
    avatar: nil
  )
end

5.times do |i|
  Relationship.create!(
    follower_id: i+3,
    followed_id: 2,
  )
end


10.times do |i|
  Category.create!(
    name: Faker::Name.name + i.to_s,
    parent_id: nil,
    description: Faker::Food.description + i.to_s
  )
end

60.times do |i|
  rate = Faker::Number.decimal(1, 1).to_f
  if rate > 5
    rate -= 5
  end
  Course.create!(
    name: Faker::Name.name,
    description: Faker::Food.description,
    rate_average: rate,
    thumbnail: nil,
    user_id: 1,
    category_id: Category.order("RAND()").first.id,
    price: 100000,
    percent_sale: 10
)
end

10.times do |i|
  rate = [1,2,3,4,5].sample
  Rating.create!(
    rating: rate,
    user_id: 1,
    course_id: Course.order("RAND()").first.id
)
end

10.times do |i|
  Comment.create!(
    content: Faker::Cat.registry,
    user_id: 1,
    course_id: Course.order("RAND()").first.id,
    parent_id: i/3 == 0 ? nil : (i/3)*3
  )
end

5.times do |i|
  Lesson.create!(
    name: Faker::LeagueOfLegends.champion + i.to_s,
    video_url: File.open(File.join(Rails.root, "app/assets/images/video.mp4")),
    course_id: Course.order("RAND()").first.id
  )
end

Wallet.create!(
  user_id: 2
)

codes = {"IJQW213VCJ" => 20000, "L5X0CUJJBR" => 50000, "056CVPOSRB" => 100000, "PWRVA15YBZ" => 20000, "T9R88YZD3J" => 500000}
codes.each do |key, value|
  Giftcode.create!(
    code: key,
    value: value
  )
end

5.times do |n|
  EWallet.create!(
    user_id: n+1
  )
end

20.times do |n|
  e_wallet_id = (n%3)+3
  number = Faker::Bank.account_number(16)
  bank = Faker::Bank.name
  card_type = Faker::Number.between(0, 4)
  expiration_date = Faker::Date.forward(700)
  name = Faker::Name.name
  gender = Faker::Number.between(0, 2)
  date_of_birth = Faker::Date.birthday(18, 65)
  address = Faker::Address.full_address
  phone = Faker::PhoneNumber.phone_number
  email = Faker::Internet.email
  employed_by = Faker::Job.title
  Credit.create!(
    e_wallet_id: e_wallet_id,
    number: number,
    bank: bank,
    card_type: card_type,
    expiration_date: expiration_date,
    name: name,
    gender: gender,
    date_of_birth: date_of_birth,
    address: address,
    phone: phone,
    email: email,
    employed_by: employed_by)
end

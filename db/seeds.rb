beach_tour = TourType.create(type_name: "Beach Tour", ancestry: nil)
mountain_tour = TourType.create(type_name: "Mountain Tour", ancestry: nil)

TourType.create(type_name: "North Beach", ancestry: beach_tour.id)
TourType.create(type_name: "South Beach", ancestry: beach_tour.id)
TourType.create(type_name: "Lowland Mountain", ancestry: mountain_tour.id)
TourType.create(type_name: "Highland Mountain", ancestry: mountain_tour.id)


30.times do |n|
	tour_name = Faker::Australia.state
	city = Faker::Address.city
	tour_destination = Faker::Address.full_address
	description = Faker::Lorem.paragraph(sentence_count: 2)
	price = Faker::Number.decimal(l_digits: 3, r_digits: 3)
	day_duration = Faker::Number.within(range: 1..29)
	start_date = Faker::Date.between(from: '2024-09-23', to: '2025-09-23')
	end_date = start_date + day_duration.days
	tour_type_id = Faker::Number.within(range: 3..6)
	Tour.create!(tour_name:, city:, tour_destination:, description:, price:, day_duration:, start_date:, end_date:, tour_type_id:)
end

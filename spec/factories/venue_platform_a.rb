FactoryGirl.define do
  factory :venue_platform do
    name 'Venue Name'
    platform_name :PlatformA
    address_1 'Example Address'
    lat 11.765915
    lng 86.32476
    category_id 1100
    closed false
    hours "10:00-22:00|10:00-22:00|10:00-22:00|10:00-22:00|10:00-22:00|11:00-18:00|11:00-18:00"
    website "www.website.com"
    phone_number "213-123-141"
  end
end

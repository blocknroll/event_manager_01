require 'csv'
require 'sunlight/congress'
require 'erb'

Sunlight::Congress.api_key = "bc756064919e4b8bb0025802325438cf"

def clean_zipcode(zipcode)
  # if the zip code is exactly 5 digits, assume that it is ok
  # if the zip code is more than 5 digits, truncate it to the first 5 digits
  # if the zip code is less than 5 digits, add zeros to the front until it becomes 5 digits
  zipcode.to_s.rjust(5, "0")[0..4]
end

def legislators_by_zipcode(zipcode)
  legislators = Sunlight::Congress::Legislator.by_zipcode("80203")

  legislator_names = legislators.collect do |legislator|
    "#{legislator.first_name} #{legislator.last_name}"
  end

  legislator_names.join(", ")
end


puts "EventManager Initialized!"

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

template_letter = File.read "form_letter.html"

contents.each do  |row|
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  legislators = legislators_by_zipcode(80203)#.join(", ")

  personal_letter = template_letter.gsub('FIRST_NAME',name)
  personal_letter.gsub!('LEGISLATORS', legislators)

  puts personal_letter
  # puts "#{name} #{zipcode} #{legislators}"


end

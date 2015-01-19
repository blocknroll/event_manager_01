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

def clean_phone_number(phone_number)

  # phone_number.to_s
end

def legislators_by_zipcode(zipcode)
  Sunlight::Congress::Legislator.by_zipcode("80203")
end

def save_thank_you_letters(id,form_letter)
  Dir.mkdir("output") unless Dir.exists? "output"

  filename = "output/thanks_#{id}.html"

  File.open(filename,'w') do |file|
    file.puts form_letter
  end
end



puts "EventManager Initialized!"

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

contents.each do  |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(80203)

  phone = row[:homephone]

  # If the phone number is less than 10 digits assume that it is a bad number
  # If the phone number is 10 digits assume that it is good
  # If the phone number is 11 digits and the first number is 1, trim the 1 and use the first 10 digits
  # If the phone number is 11 digits and the first number is not 1, then it is a bad number
  # If the phone number is more than 11 digits assume that it is a bad number

  # phone.chars
  # remove extra chars '.' '-'


  if phone.length < 10
    # assume bad
    puts 'bad phone. < 10'
    puts phone

    elsif phone.length == 11 && phone[0] == 1
      phone = phone[1..10]
      puts phone

    elsif phone.length == 11 && phone[0] != 1
      # assume bad
      puts 'bad phone. 11 & 1'
      puts phone

    elsif phone.length > 11
      # assume bad
      puts 'bad phone. > 11'
      puts phone

    else
      # assume good
      puts phone

  end

  # puts phone




  form_letter = erb_template.result(binding)

  # save_thank_you_letters(id,form_letter)
end

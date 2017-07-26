require_relative 'bot'

bot = Bot.new(:name => 'Beth', :data_file => 'bot_data_to_yaml.rb')

#puts bot.greeting

while input = gets and input.chomp != 'end'
	puts '<< ' + bot.response_to(input)
end

puts bot.farewell
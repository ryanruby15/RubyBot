require 'yaml'
require_relative 'wordplay'

class Bot
	attr_reader :name

	def initialize(options)
		@name = options[:name] || "Unnamed Bot"
		begin
			@data = YAML.load(File.read(options[:data_file]))
		rescue
			raise "Can't load bot data"
		end
	end
end

public

# Give a random greeting
def greeting
	random_response :greeting
end

# Give a random farewell
def farewell
	random_response :farewell
end

# Method to take an input and find a response
def response_to(input)
	prepared_input = preprocess(input).downcase
	sentence = best_sentence(prepared_input)
	responses = possible_responses(sentence)
	responses[rand(responses.length)]
end

# Method to find possible responses to the user input
def possible_responses(sentence)
	responses = Array.new

	# Find all paterns to try to match against
	@data[:responses].keys.each do |pattern|
		next unless pattern.is_a?(String)

		# For each pattern, see if the supplied sentence contains
		# a match. Remove substitution symbols (*) before checking.
		# Push all responses to the responses array.
		if sentence.match('\b' + pattern.gsub(/\*/, '') + '\b')
			# If the pattern contains substitution placeholders,
			# perform the substitutions.
			if pattern.include?('*')
				responses << @data[:responses][pattern].collect do |phrase|
					# First, erase everything before the placeholder
					# leaving everything after it
					matching_section = sentence.sub(/^.*#{pattern}\s+/, '')

					# Then substitue the test after the placeholder, with
					# the pronouns switched
					phrase.sub('*', WordPlay.switch_pronouns(matching_section))
				end
			else
				# No placeholders? Just add the phrases to the array
			responses << @data[:responses][pattern]
		end	
	end
end

	# If there were no matches, add the default ones
	responses << @data[:responses][default] if responses.empty?

	# Flatten the blocks of responses to a flat array
	responses.flatten
end

private

# Private method to pick a random response from our bot data file
def random_response(key)
	random_index = rand(@data[:responses][key].length)
	@data[:responses][key][random_index].gsub(/\[name\]/, @name)
end

# Method to process the input into a form we like
def preprocess(input)
	perform_substitutions input
end

# Perform the substitutions
def perform_substitutions(input)
	@data[:presubs].each { |s| input.gsub!(s[0], s[1]) }
	input
end

# Method to find the best sentence
def best_sentence(input)
	# Select the words in the data hash, from the responses that
	# are a string and also just one word.
	hot_words = @data[:responses].keys.select do |k|
		k.class == String && k=~ /^\w+$/
	end

	WordPlay.best_sentence(input.sentences, hot_words)
end



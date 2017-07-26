#============================================================
# A class to allow the bot to play with words and decide how
# to respond to user input.
#============================================================


class WordPlay

	# Method to return the sentence with the most hot words
	def self.best_sentence(sentences, hot_words)
		ranked_sentences = sentences.sort_by do |s|
		s.words.length - (s.downcase.words - hot_words).length
	end

	ranked_sentences.last
	end

	# Method to switch pronouns
	def self.switch_pronouns(text)
		text.gsub(/\b(I am|You are|I|You|Me|Your|My)\b/i) do |pronoun|
			case pronoun.downcase
			when "i"
				"you"
			when "you"
				"me"
			when "me"
				"you"
			when "i am"
				"you are"
			when "you are"
				"I am"
			when "your"
				"my"
			when "my"
				"your"
			end
		end.sub(/^me\b/i, 'i')
	end

end

class String

	# Method to split a string into an array of sentences
	def sentences
		gsub(/\n|\r/, ' ').split(/\.\s*/)
	end

	# Method to split a sentence into an array of words
	def words
		scan(/\w[\w\'\-]*/)
	end
	
end



# Should evaluate to "test"
%q{Hello. This is a test of basic sentence splitting. It
even works over multiple
line.}.sentences[1].words[3]

hot_words = %w{test ruby}

my_string = "This is a test. Dull sentence here. Ruby is great.
			So is cake."
# Find all the sentences that include a hot word.
my_string.sentences.find_all do |s|
	s.downcase.words.any? { |word| hot_words.include?(word) }
end






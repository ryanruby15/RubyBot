require 'test/unit'
require './wordplay'

class TestWordPlay < Test::Unit::TestCase

	# A test for the sentences method
	def test_sentences
		assert_true("a. b. cd. efg.".sentences == ["a", "b", "cd", "efg"])
		
		test_text = %q{Hello. This is a test
			of sentence seperation. This is the end of the test.}
			assert_equal("This is the end of the test", test_text.sentences[2])

	end

	# A test for the method that chooses the "best" sentence
	def test_sentence_choice
		assert_equal('This is a great test',
					WordPlay.best_sentence(['This is a test',
											'This is another test',
											'This is a great test'],
											%w{test great this}))
		assert_equal('This is a great test',
					WordPlay.best_sentence(['This is a great test'],
											%w{still the best}))
	end

	# A test for some basic pronoun switches
	def test_basic_pronouns
		assert_equal("I am a robot", WordPlay.switch_pronouns("you are a robot"))
		assert_equal("you are a person", WordPlay.switch_pronouns("i am a person"))
		assert_equal("i love you", WordPlay.switch_pronouns("you love me"))
	end

end
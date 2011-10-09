require 'test/unit'
require 'rubygems'
require 'captcha_maker/captcha_impls'


class CaptchaImplsTest < Test::Unit::TestCase
	#
	# make sure we can construct
	#
	def test_init
		assert_nothing_raised do
			foo = CaptchaImpls::MathCaptcha.new()
		end
	end

	def test_getRandomSymbolEventuallyGetsAll()
		tst = CaptchaImpls::MathCaptcha.new()
		testSym = ['*','+','-','/']
		t = 0
		while ( testSym.length > 0 )
			tst_sym = tst.getRandomSymbol()
			testSym.delete_if{|x| x == tst_sym }
			if ( t == 99 )
				assert(false, "we should have been able to get through all symbols before 100 attempts.")
			end
			t = t.next
		end
	end

	def test_generateRandomProblemNoRemaindersForDivision
		mathmaker = CaptchaImpls::MathCaptcha.new()
		mathmaker.generateRandomProblem()
		prob = mathmaker.problem
		assert_not_nil(prob, "the problem should not be nil")
		attempts = 1
		while ( !(mathmaker.symbol == '/') )
			mathmaker.generateRandomProblem()
			prob = mathmaker.problem
			attempts = attempts.next
		end
		parts = prob.split(/\//)
		begin
			remainder = parts[0].to_i % parts[1].to_i
		rescue ZeroDivisionError
			# we're friggin fine...
			remainder = 0
		end
		assert_equal(0,remainder, "there should be no remainder")

	end

	def test_generateRandomProblemNoNegativesForSubtraction
		100.times do
			mathmaker = CaptchaImpls::MathCaptcha.new()
			mathmaker.generateRandomProblem()
			prob = mathmaker.problem
			assert_not_nil(prob, "the problem should not be nil")
			attempts = 1
			while ( !(mathmaker.symbol == '-') )
				mathmaker.generateRandomProblem()
				prob = mathmaker.problem
				attempts = attempts.next
			end
			answer = eval prob
			assert(answer >= 0, "no subtraction probs should return negative")
		end
	end

	def test_generateRandomProblem_sRandomness
		50.times do
			random_probs = Array.new
			mathmaker = CaptchaImpls::MathCaptcha.new()
			100.times do
				problem = mathmaker.generateRandomProblem()
				random_probs << problem
			end
			problem = mathmaker.generateRandomProblem()
			assert( !(random_probs.include?(problem)), "not random enough")
		end
	end


end

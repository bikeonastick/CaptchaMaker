require 'test/unit'
require 'rubygems'
require 'captcha_maker'


class CaptchaMakerTest < Test::Unit::TestCase
	#
	# make sure buildText() does not throw, which it would if
	# addCharacter couldn't find the font library.
	#
	def test_buildText
		foo = CaptchaMaker::CaptchaImage.new("1325+2=")
		assert_nothing_raised do
			foo.buildText()
		end
	end

	def test_addCharacterForCaptchaFontException
		foo = CaptchaMaker::CaptchaImage.new("1325+2=",
									 nil,
									 100,
									 60,
									 'courier',
									 'foopic.png')
		assert_raise( CaptchaMaker::CaptchaFontException ) { 
			foo.addCharacter('x',1,60)
		}
	end

	def test_addCharacterForCaptchaFontExceptionChar
		foo = CaptchaMaker::CaptchaImage.new("1325+2=",
									 nil,
									 100,
									 60,
									 'arial',
									 'foopic.png')
		assert_raise( CaptchaMaker::CaptchaFontException ) { 
			foo.addCharacter('1',1,60)
		}
	end


end

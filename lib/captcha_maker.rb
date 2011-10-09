############################################################################
#  Copyright 2011 robert tomb (bikeonastick)                               #
#                                                                          #
#  Licensed under the Apache License, Version 2.0 (the "License");         #
#  you may not use this file except in compliance with the License.        #
#  You may obtain a copy of the License at                                 #
#                                                                          #
#  http://www.apache.org/licenses/LICENSE-2.0                              #
#                                                                          #
#  Unless required by applicable law or agreed to in writing, software     #
#  distributed under the License is distributed on an "AS IS" BASIS,       #
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.#
#  See the License for the specific language governing permissions and     #
#  limitations under the License.                                          #
############################################################################



require 'chunky_png'
include ChunkyPNG::Color

#
# Collection of classes that create text in PNGs using the very
# excellent <a href="https://github.com/wvanbergen/chunky_png">
# chunky png</a>. 
module CaptchaMaker


	#
	# Used to create the raw image of the +text+ on a png. This is very
	# unsophisticated and creates the pngs from a library of characters.
  class CaptchaImage

    def initialize(text,
									 width=nil,
									 height=100,
									 pix_offset=60,
									 font='courier',
									 img_name='foopic.png')
      @pixel_offset = pix_offset
			# get font lib set to default
			curr_dir = File.dirname(__FILE__)
			font_path = "#{curr_dir}/captcha_maker/png_chars"
			self.setFontLib(font,font_path)
      @font = font
      @w = width
			if(@w == nil)
				@w = text.length * pix_offset
			end
      @h = height
      @name = img_name
      @captcha = ChunkyPNG::Image.new(@w, @h, WHITE)
      @captcha_txt = text
      
    end

    def buildText
      pos = 0
      @captcha_txt.each_char{|c|
        char = "?#{c}"
        charcode = eval(char)
        self.addCharacter(charcode,pos,@pixel_offset)
        pos = pos.next
      }
    end

		#
		# Can be used to point this to your own library for a font. Remember, a 
		# font is in <location>/<name> and each file uses the convention 
		# cm_<ASCII letter number>.png, e.g., the number 3 can be found in 
		# cm_51.png
		#
		def setFontLib(name,location)
			@font = name
			@font_lib = CaptchaFont.new(name,location)

		end


    

    def saveCaptcha(location)
      @captcha.save("#{location}/#{@name}")

    end

    #
    # Adds a png snippet that represents the character in c_to_add. The
    # char's ascii representation is grabbed and is used to grab the file
    # saved in the font library named with the convention:
    #
    # cm_<ascii decimal val>.png 
    # e.g.
    # for the number 1, it would fetch cm_49.png
    #
    def addCharacter(c_to_add,pos,pix_offset)
			font_path = @font_lib.font_path
			if ( !File.exist?(font_path) )
				raise CaptchaFontException, "the #{@font} font was not found."
			end
			img_path = @font_lib.getCharImgLoc(c_to_add)
			if ( !File.exist?(img_path) )
				raise CaptchaFontException, 
					"the char #{c_to_add} was not found in the font library."
			end
      img_chunk = ChunkyPNG::Canvas.from_file(img_path)
      offset = pos * pix_offset 
      @captcha.compose!(img_chunk,offset)
    end

  end

	class CaptchaFontException < StandardError
		def initialize(character)
			@missing_char = character
		end
	end
	
	# 
	# Convenience class for the fonts used by CaptchaMaker. Font libraries
	# are made up of files that represent each printable character in the ASCII
	# table. They are expected to use the following naming convention:
	#
	# cm_<ascii num>.png
	# e.g.
	# cm_49.png is for the number 1
	#
	class CaptchaFont

		# 
		# If you need to read the font path, get that here.
		#
		attr_reader :font_path

		# 
		# If you need the name of the font represented by this object, boom, 
		# get it here...
		#
		attr_reader :font_name

		# Pass in the location (path to directory that contains +font_name+
		def initialize(font_name,location)
			@font_name = font_name
			@font_path = "#{location}/#{@font_name}"
		end

		# 
		# returns the location of the png from the font library that is 
		# associated with the passed-in character.
		#
		def getCharImgLoc(char)
      "#{font_path}/cm_#{char}.png"
		end
	end


  # string (representing problem)
  # generates problem obj
  # problem object with problem text, solution, stream for picture
  # picture should have mild skew and softening to problem text
end
#foo = CaptchaMaker::CaptchaImage.new("1325+2=", "foopic.png",660,100,"courier",60)
#foo.saveCaptcha(".")


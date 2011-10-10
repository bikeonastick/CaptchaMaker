lib = File.expand_path('../lib/', __FILE__) 
$:.unshift lib unless $:.include?(lib) 

Gem::Specification.new do |s| 
	s.name = "captcha_maker" 
	s.license = "Apache License, Version 2.0" 
	s.version = "0.1.2"
	s.platform = Gem::Platform::RUBY 
	s.author = "robert tomb" 
	s.email = "bikeonastick@gmail.com" 
	s.homepage = "http://bikeonastick.blogspot.com/p/open-source-projects.html#captcha_maker" 
	s.summary = "A pure ruby way to create png-based captchas."
	s.description = "Includes an impl for making math captchas with a limited set of a courier font characters. You can create/add your own png-based font libraries to create other captchas. See README for more info on font library requirements."
	s.required_rubygems_version = ">= 1.3.5" 
	s.add_dependency('chunky_png', '>= 1.2.1')
	s.files = Dir.glob("{lib}/**/*") + %w(LICENSE README ROADMAP) 
	s.require_path = 'lib' 
	s.rdoc_options << '--title' 
	s.rdoc_options << 'CaptchaMaker: for pure Ruby png-captchas' 
	s.rdoc_options << '--main' 
	s.rdoc_options << 'README' 
	s.rdoc_options << '--line-numbers'
end

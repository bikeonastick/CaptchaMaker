require 'rake/testtask'
require 'rake/clean'
require 'rdoc/task'

gemspec = eval(File.read(Dir["*.gemspec"].first))

CLEAN.include('pkg','rdoc')

desc "Validate the gemspec"
task :gemspec do
	  gemspec.validate
end

desc "Build gem locally"
task :build => [:gemspec, :clean, :prep ]do
	system "gem build #{gemspec.name}.gemspec"
	FileUtils.mkdir_p "pkg"
	FileUtils.mv "#{gemspec.name}-#{gemspec.version}.gem", "pkg"
end

desc "Install gem locally"
task :install => :build do
	system "gem install pkg/#{gemspec.name}-#{gemspec.version}"
end

desc "uninstall local gem"
task :uninstall do
	system "gem uninstall #{gemspec.name} -v #{gemspec.version}"
end

desc "prepare directories"
task :prep do
	FileUtils.mkdir "pkg"
	FileUtils.mkdir "rdoc"
end

desc "generate documentation"
RDoc::Task.new do |rdoc|
		rdoc.rdoc_dir = 'rdoc'
		rdoc.main = "README"
		rdoc.rdoc_files.include("README", "LICENSE", "lib/**/*\.rb")
		rdoc.options << '--title' 
		rdoc.options << 'CaptchaMaker: for pure Ruby png-captchas' 
		rdoc.options << '--line-numbers'

end

Rake::TestTask.new('test') do |t|
	t.pattern = 'test/**/*_test.rb'
	t.warning = true
end

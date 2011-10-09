require 'rake/testtask'

gemspec = eval(File.read(Dir["*.gemspec"].first))

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

desc "Clean automatically generated files"
task :clean do
	FileUtils.rm_rf "pkg"
end

desc "prepare directories"
task :prep do
	FileUtils.mkdir "pkg"
end

desc "clean generated files"
task :clean do
end

Rake::TestTask.new('test') do |t|
	t.pattern = 'test/**/*_test.rb'
	t.warning = true
end

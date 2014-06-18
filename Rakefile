require "bundler/gem_tasks"

gemspec = eval(File.read("flavours.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["flavours.gemspec"] do
  system "gem build flavours.gemspec"
end
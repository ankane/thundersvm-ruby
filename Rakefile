require "bundler/gem_tasks"
require "rake/testtask"
require "ruby_memcheck"

test_config = lambda do |t|
  t.pattern = "test/**/*_test.rb"
end
Rake::TestTask.new(&test_config)

namespace :test do
  RubyMemcheck::TestTask.new(:valgrind, &test_config)
end

task default: :test

def download_file(file)
  require "open-uri"

  url = "https://github.com/ankane/ml-builds/releases/download/thundersvm-0.3.4/#{file}"
  puts "Downloading #{file}..."
  dest = "vendor/#{file}"
  File.binwrite(dest, URI.parse(url).read)
  puts "Saved #{dest}"
end

namespace :vendor do
  task :linux do
    download_file("libthundersvm.so")
  end

  task :mac do
    download_file("libthundersvm.dylib")
    download_file("libthundersvm.arm64.dylib")
  end

  task :windows do
    download_file("thundersvm.dll")
  end

  task all: [:linux, :mac, :windows]
end

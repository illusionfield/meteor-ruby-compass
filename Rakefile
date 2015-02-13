require 'rubygems' unless defined? Gem 

task :default => :start

task :start do
  sh %Q{bundle install --standalone --clean} do |ok, res|
    puts "fail to install gems (status = #{res.exitstatus})" unless ok
  end
end

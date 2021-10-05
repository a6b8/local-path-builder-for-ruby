require './lib/local_path_builder'
require 'fileutils'  

Gem::Specification.sort{|a,b| a.name <=> b.name}.map {|a| puts "#{a.name} (#{a.version})"; puts "-" * 50; puts a.homepage; puts a.description; puts "\n\n"}

struct = LocalPathBuilder.helper()

[ :silent, :hash, :path, :both ].each do | key |
    puts "#{key.to_s.upcase}: "
    LocalPathBuilder.generate( struct, key )
    puts
end
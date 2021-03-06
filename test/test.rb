require '../lib/local_path_builder'
  
struct = LocalPathBuilder.helper()

[ :silent, :hash, :path, :both ].each do | key |
    puts "#{key.to_s.upcase}: "
    LocalPathBuilder.generate( struct, key )
    puts
end
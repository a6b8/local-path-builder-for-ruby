  
  require '../lib/local_path_builder'
  
  hash = LocalPathBuilder.helper()

  LocalPathBuilder.generate( hash[:path], 1 )

  puts hash[:path][:children][:converted][:children][:tsv_folder][:files][:tsv][:full]

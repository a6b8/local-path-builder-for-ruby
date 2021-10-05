# frozen_string_literal: true

require_relative "local_path_builder/version"
require 'fileutils'


module LocalPathBuilder
  class Error < StandardError; end

  
  def self.helper()
    result = {
      root: './',
      name: '1',
      children: {
        entry: {
          name: '0-entry',
          files: {
            tsv: {
              name: 'rest-{{SALT}}.tsv',
            }
          }
        },
        converted: {
          name: '1-converted',
          children: {
              json_folder: {
                  name: '0-json',
                  files: {
                      json: {
                          name: 'data-{{SALT}}.json',
                      }
                  }
              },
              tsv_folder: {
                  name: '0-tsv',
                  files: {
                      tsv: {
                          name: 'data-{{SALT}}.json',
                      }
                  }
              }
          },
          files: {
            json: {
              name: 'data-{{SALT}}.json',
            } 
          }
        }
      }
    }
    return result
  end


  def self.generate( obj, status, salt=Time.now.getutc.to_i.to_s )
    mode = {
      general: nil,
      hash: nil,
      path: nil
    }
      
    case status
      when :silent
        mode[:general] = false
        mode[:hash] = false
        mode[:path] = false
      when :hash
        mode[:general] = true
        mode[:hash] = true
        mode[:path] = false
      when :path
        mode[:general] = true
        mode[:hash] = false
        mode[:path] = true
      when :both
        mode[:general] = true
        mode[:hash] = true
        mode[:path] = true
    end
    
    
    mode[:general] ? puts( 'TREE OVERVIEW' ) : ''
    
    obj[:full] = ''
    obj[:full] += obj[:root]
    obj[:full] += self.helper_parse_path( self.helper_insert_salt( salt, obj[:name] ) )
    
    mode[:hash] ? puts( self.helper_obj_path( 'l1', salt, [ ] ) ) : ''
    mode[:path] ? puts( self.draw_obj_path_local( obj[:full], 2, 4 ) ) : ''
  
    obj[:children].keys.each { | l2 | 
        obj[:children][ l2 ][:full] = ''
        obj[:children][ l2 ][:full] += obj[:full]
        obj[:children][ l2 ][:full] += self.helper_parse_path( self.helper_insert_salt( salt, obj[:children][ l2 ][:name] ) )
        mode[:hash] ? puts( self.helper_obj_path( 'l2', salt, [ l2 ] ) ) : ''
        mode[:path] ? puts( self.draw_obj_path_local( obj[:children][ l2 ][:full], 3, 4 ) ) : ''
        FileUtils.mkdir_p obj[:children][ l2 ][:full]
  
        if !obj[:children][ l2 ][:files].nil?
          obj[:children][ l2 ][:files].keys.each { | f1 | 
            obj[:children][ l2 ][:files][ f1 ][:full] = '' 
            obj[:children][ l2 ][:files][ f1 ][:full] += obj[:children][ l2 ][:full] 
            obj[:children][ l2 ][:files][ f1 ][:full] += self.helper_insert_salt( salt, obj[:children][ l2 ][:files][ f1 ][:name] )
            mode[:hash] ? puts( self.helper_obj_path( 'l2', salt, [ l2 ], f1 ) ) : ''
            mode[:path] ? puts( self.draw_obj_path_local( obj[:children][ l2 ][:files][ f1 ][:full], 3, 4 ) ) : ''
          }
        end
  
        if !obj[:children][ l2 ][:children].nil?
          obj[:children][ l2 ][:children].keys.each { | l3 | 
            obj[:children][ l2 ][:children][ l3 ][:full] = ''
            obj[:children][ l2 ][:children][ l3 ][:full] += obj[:children][ l2 ][:full]
            obj[:children][ l2 ][:children][ l3 ][:full] += self.helper_parse_path( self.helper_insert_salt( salt, obj[:children][ l2 ][:children][ l3 ][:name] ) )
  
            FileUtils.mkdir_p obj[:children][ l2 ][:children][ l3 ][:full]
            mode[:hash] ? puts( self.helper_obj_path( 'l3', salt, [ l2, l3 ] ) ) : ''
            mode[:path] ? puts( self.draw_obj_path_local( obj[:children][ l2 ][:children][ l3 ][:full], 4, 4 ) ) : ''
  
            if !obj[:children][ l2 ][:children][ l3 ][:files].nil?
              obj[:children][ l2 ][:children][ l3 ][:files].keys.each { | f2 | 
                obj[:children][ l2 ][:children][ l3 ][:files][ f2 ][:full] = ''
                obj[:children][ l2 ][:children][ l3 ][:files][ f2 ][:full] += obj[:children][ l2 ][:children][ l3 ][:full]
                obj[:children][ l2 ][:children][ l3 ][:files][ f2 ][:full] += self.helper_insert_salt( salt, obj[:children][ l2 ][:children][ l3 ][:files][ f2 ][:name] )
                mode[:hash] ? puts( self.helper_obj_path( 'l3', salt, [ l2, l3 ], f2 ) ) : ''
                mode[:path] ? puts( self.draw_obj_path_local( obj[:children][ l2 ][:children][ l3 ][:files][ f2 ][:full], 4, 4 ) ) : ''
              }
            end
          }
        end
    }
    return obj
  end


  private

  def self.helper_parse_path( str )
    if str[ str.length - 1, 1 ] != '/'
      str = str + '/'
    end
    return str
  end

  def self.draw_obj_line_edge( l, offset )
      str = ''
      for i in 1..( ( l - 1 ) * offset )
        str += ' '
      end
      if l > 1
        str += "┗"
        str += "━"
        str += " "
      else
        str += '    '
      end
      return str
  end
  
  def self.draw_obj_path_local( str, l, offset )
    result = ''
    for i in 0..( ( l - 1 ) * offset )
      result += ' '
    end
    result += ''
    result += str
    return result
  end

  def self.helper_obj_path( name, salt, k, f=nil )
    str = ''
    str += self.draw_obj_line_edge( name[ 1, name.length ].to_i, 4 )
    str += 'hash[:path]'
    if k.length == 0

    else
      for i in 0..k.length-1
        str += '[:children]'
        str += '[:'
        str += k[ i ].to_s
        str += ']'      
      end
    end

    if !f.nil?
      str += '[:files][:'
      str += f.to_s
      str += '][:full]'    
    else
      str += '[:full]'
    end
    return str
  end
  
  def self.helper_insert_salt( salt, str )
    str = str.gsub( "{{SALT}}", salt )
    return str
  end
end
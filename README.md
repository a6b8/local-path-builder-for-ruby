<a href="#table-of-contents">
<img src="https://raw.githubusercontent.com/a6b8/a6b8/main/assets/headlines/custom/local-path-builder-for-ruby.svg" height="45px" name="# Local Path Builder for Ruby" alt="Local Path Builder for Ruby">
</a>

Usefull helper to build all paths in one hash to local files and folders.

<br>

<a href="#headline">
<img src="https://raw.githubusercontent.com/a6b8/a6b8/main/assets/headlines/default/table-of-contents.svg" height="45px" name="table-of-contents" alt="Table of Contents">
</a>
<br>

1. [Quickstart](#quickstart) 
2. [Setup](#setup)
3. [Methods](#methods)
4. [Tree Structure](#tree-structure)
5. [Console Output](#console)
6. [Contributing](#contributing)
7. [Limitations](#limitations)
8. [License](#license)
9. [Code of Conduct](#code-of-conduct)
10. [Support my Work](#support-my-work)

<br>

<a href="#table-of-contents">
<img src="https://raw.githubusercontent.com/a6b8/a6b8/main/assets/headlines/default/quickstart.svg" height="45px" name="quickstart" alt="Quickstart">
</a>

```ruby
require 'local_path_builder'

struct = LocalPathBuilder.helper()
LocalPathBuilder.generate( struct, :both )
```

<br>

<a href="#table-of-contents">
<img src="https://raw.githubusercontent.com/a6b8/a6b8/main/assets/headlines/default/setup.svg" height="45px" name="setup" alt="Setup">
</a>

Add this line to your application's Gemfile:

```ruby
gem 'local_path_builder'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install local_path_builder


On Rubygems: 
- Gem: https://rubygems.org/gems/local_path_builder
- Profile: https://rubygems.org/profiles/a6b8

<br>

<a href="#table-of-contents">
<img src="https://raw.githubusercontent.com/a6b8/a6b8/main/assets/headlines/default/methods.svg" height="45px" name="methods" alt="Methods">
</a>

### .helper()

```ruby
require 'local_path_builder'

hash = LocalPathBuilder.helper()
# => { path: 
```

### .generate( struct[:path], key )

```ruby
require 'local_path_builder'

hash = LocalPathBuilder.generate( 
    path_tree, 
    console_mode,  
    salt 
)
```

**Input**
| **Type** | **Required** | **Description** | **Example** | **Description** |
|------:|:------|:------|:------|:------| 
| **path tree** | ```Hash``` | Yes | please refer `path structure` | Define path structure |
| **console mode** | ```Symbol``` | Yes | ```:hash``` | Set console output mode. Use ```:silent```, ```:hash```, ```:path``` or ```:both``` |
| **salt** | ```String``` | No | ```'1624262108'``` | Use salt to create unique filenames. |

**Return**<br>
Hash (See also Console Output)

<br>

<a href="#table-of-contents">
<img src="https://raw.githubusercontent.com/a6b8/a6b8/main/assets/headlines/default/tree-structure.svg" height="45px" name="tree-structure" alt="Tree Structure">
</a>

A struct input is required to generate all paths. Use the following as reference to design your own tree

**Example Tree**

```ruby
{
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
```
```LocalPathBuiler.helper()``` will give you the same output.

<br>

<a href="#table-of-contents">
<img src="https://raw.githubusercontent.com/a6b8/a6b8/main/assets/headlines/default/console.svg" height="45px" name="console" alt="Console Output">
</a>

The second parameter of the ```.generate()``` function expects a symbol. you can choose between ```:silent```, ```:hash```, ```path``` and ```both```. 

### :silent
Console stays silent.

### :hash
Console log all variables which are available.

```txt
LocalPathBuilder.generate( struct, :hash )

TREE OVERVIEW
    hash[:path][:full]
    ┗━ hash[:path][:children][:entry][:full]
    ┗━ hash[:path][:children][:entry][:files][:tsv][:full]
    ┗━ hash[:path][:children][:converted][:full]
    ┗━ hash[:path][:children][:converted][:files][:json][:full]
        ┗━ hash[:path][:children][:converted][:children][:json_folder][:full]
        ┗━ hash[:path][:children][:converted][:children][:json_folder][:files][:json][:full]
        ┗━ hash[:path][:children][:converted][:children][:tsv_folder][:full]
        ┗━ hash[:path][:children][:converted][:children][:tsv_folder][:files][:tsv][:full]
```


### :path
Console log all path which were created.

```
LocalPathBuilder.generate( struct, :path )

TREE OVERVIEW
    ./1/
        ./1/0-entry/
        ./1/0-entry/rest-1624263104.tsv
        ./1/1-converted/
        ./1/1-converted/data-1624263104.json
            ./1/1-converted/0-json/
            ./1/1-converted/0-json/data-1624263104.json
            ./1/1-converted/0-tsv/
            ./1/1-converted/0-tsv/data-1624263104.json
```


### :both
Console log hash variable and the corresponding file path.

```txt
LocalPathBuilder.generate( struct, :both )

TREE OVERVIEW
    hash[:path][:full]
    ./1/
    ┗━ hash[:path][:children][:entry][:full]
        ./1/0-entry/
    ┗━ hash[:path][:children][:entry][:files][:tsv][:full]
        ./1/0-entry/rest-1624263104.tsv
    ┗━ hash[:path][:children][:converted][:full]
        ./1/1-converted/
    ┗━ hash[:path][:children][:converted][:files][:json][:full]
        ./1/1-converted/data-1624263104.json
        ┗━ hash[:path][:children][:converted][:children][:json_folder][:full]
            ./1/1-converted/0-json/
        ┗━ hash[:path][:children][:converted][:children][:json_folder][:files][:json][:full]
            ./1/1-converted/0-json/data-1624263104.json
        ┗━ hash[:path][:children][:converted][:children][:tsv_folder][:full]
            ./1/1-converted/0-tsv/
        ┗━ hash[:path][:children][:converted][:children][:tsv_folder][:files][:tsv][:full]
            ./1/1-converted/0-tsv/data-1624263104.json
```

<br>

<a href="#table-of-contents">
<img src="https://raw.githubusercontent.com/a6b8/a6b8/main/assets/headlines/default/contributing.svg" height="45px" name="contributing" alt="Contributing">
</a>

Bug reports and pull requests are welcome on GitHub at https://github.com/a6b8/statosio-for-wordpress. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/a6b8/statosio/blob/master/CODE_OF_CONDUCT.md).

<br>

<a href="#table-of-contents">
<img src="https://raw.githubusercontent.com/a6b8/a6b8/main/assets/headlines/default/limitations.svg" height="45px" name="limitations" alt="Limitations">
</a>

- Only three levels of folders are supported
  
<br>

<a href="#table-of-contents">
<img src="https://raw.githubusercontent.com/a6b8/a6b8/main/assets/headlines/default/license.svg" height="45px" name="license" alt="License">
</a>

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

<br>

<a href="#table-of-contents">
<img src="https://raw.githubusercontent.com/a6b8/a6b8/main/assets/headlines/default/code-of-conduct.svg" height="45px" name="code-of-conduct" alt="Code of Conduct">
</a>
    
Everyone interacting in the LocalPathBuilder project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/a6b8/local-path-builder-for-ruby/blob/master/CODE_OF_CONDUCT.md).

<br>

<a href="#table-of-contents">
<img href="#table-of-contents" src="https://raw.githubusercontent.com/a6b8/a6b8/main/assets/headlines/default/star-us.svg" height="45px" name="star-us" alt="Star us">
</a>

Please ⭐️ star this Project, every ⭐️ star makes us very happy!
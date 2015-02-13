require 'compass/import-once/activate'

# Other paths on your system from which to import sass files. See the add_import_path function for a simpler approach. (Array of Strings)
#additional_import_paths = [ "packages/meteor-ruby-compass" ]

# Not needed in :stand_alone mode where it can be inferred by context. Sets the path to the root of the project. (String)
project_path = File.dirname(__FILE__) + '/'

# Can be :stand_alone or :rails. Defaults to :stand_alone. (Symbol)
project_type = :stand_alone

# The environment mode. Defaults to :development, can also be :production (Symbol)
environment = :development

# You can select your preferred output style here (can be overridden via the command line):
#output_style = (environment == :production) ? :compressed : :expanded

# Indicates whether the compass helper functions should generate relative urls from the generated css to assets, or absolute urls using the http path for that asset type. (Boolean)
relative_assets = true

# Set this to true to enable sourcemap output. (Boolean)
sourcemap = true

# Set this to true to silence deprecation warnings. (Boolean)
disable_warnings = false

# Indicates whether line comments should be added to compiled css that says where the selectors were defined. Defaults to false in production mode, true in development mode. (Boolean)
line_comments = false

# Can be :scss or :sass. Defaults to :scss. /sass-convert -R --from scss --to sass sass scss && rm -rf sass && mv scss sass/ (Symbol) 
preferred_syntax = :sass

# The path to the project when running within the web server. Defaults to "/". (String)
http_path = "/"

# The directory where the css stylesheets are kept. It is relative to the project_path. Defaults to "stylesheets". (String)
#css_dir = "stylesheets"

# The directory where the sass stylesheets are kept. It is relative to the project_path. Defaults to "sass". (String)
#sass_dir = "sass"

# The directory where the images are kept. It is relative to the project_path. Defaults to "images". (String)
#images_dir = "images"

# The directory where the javascripts are kept. It is relative to the project_path. Defaults to "javascripts". (String)
#javascripts_dir = "javascripts"

# The directory where the font files are kept. Standalone projects will default to <css_dir>/fonts. Rails projects will default to "public/fonts". (String)
#fonts_dir = "public/fonts"


########################## Advanced ##########################

# These options are passed directly to the Sass compiler. For more details on the format of sass options, please read the sass options documentation. (Hash)
#sass_options = {:trace => true, :cache => true}

# The full path to where css stylesheets are kept. Defaults to <project_path>/<css_dir>. (String)
#css_path =

# The full http path to stylesheets on the web server. Defaults to http_path + "/" + css_dir. (String)
#http_stylesheets_path =

# The full path to where sass stylesheets are kept. Defaults to <project_path>/<sass_dir>. (String)
#sass_path = 

# The full path to where images are kept. Defaults to <project_path>/<images_dir>. (String)
#images_path = project_path + 'public/' + images_dir

# The full http path to images on the web server. Defaults to http_path + "/" + images_dir. (String)
#http_images_path =

# The directory where generated images are kept. It is relative to the project_path. Defaults to the value of images_dir. (String)
#generated_images_dir =

# The full path to where generated images are kept. Defaults to the value of <project_path>/<generated_images_dir>. (String)
#generated_images_path =

# The full http path to generated images on the web server. Defaults to http_path + "/" + generated_images_dir. (String)
#http_generated_images_path =

# The full path to where javascripts are kept. Defaults to <project_path>/<javascripts_dir>. (String)
#javascripts_path = 

# The full http path to javascripts on the web server. Defaults to http_path + "/" + javascripts_dir. (String)
#http_javascripts_path =

# The full path to where font files are kept. Defaults to <project_path>/<fonts_dir>. (String)
#fonts_path = 

# The full http path to font files on the web server. (String)
#http_fonts_path = http_path + fonts_dir

# The relative http path to font files on the web server. (String)
#http_fonts_dir = fonts_dir

# Defaults to :chunky_png (Symbol)
#sprite_engine =

# Defaults to {:compression => Zlib::BEST_COMPRESSION}. See the chunky_png wiki for more information (Hash)
#chunky_png_options = {:compression => Zlib::BEST_COMPRESSION}

# Defaults to [images_path] (Array)
#sprite_load_path =


########################## Functions ##########################

# Call this function to add a path to the list of sass import paths for your compass project.
#add_import_path "private/bower"

# Pass this function a block of code that defines the cache buster strategy to be used. The block must return nil, a string or a hash. If the returned value is a hash the values of :path and/or :query is used to generate a cache busted path to the asset. If a string value is returned, it is added as a query string. The returned values for query strings must not include the starting ?
#asset_cache_buster :none

# React to changes to arbitrary files within your project. Can be invoked more than once. 
#watch "images/**/*" do |project_dir, relative_path|
#  if File.exists?(File.join(project_dir, relative_path))
#    puts "File size of #{relative_path} is: #{File.size(File.join(project_dir, relative_path))}"
#  end
#end


########################## Callbacks ##########################

# Pass this function a block of code that gets executed after a sprite is saved to disk. The block will be passed the filename. Can be invoked more then once. Example:
#on_sprite_saved do |filename|
#  post_process(filename) if File.exists?(filename)
#end

# Pass this function a block of code that gets executed after a sprite is generated but before its saved to disk. The block will be passed an instance of ChunkyPNG::Image. Can be invoked more then once. Example:
#on_sprite_generated do |sprite_data|
#  sprite_data.metadata['Caption'] = "This Image is &copy; My Company 2011"
#end


#Pass this function a block of code that gets executed after a stylesheet is processed. The block will be passed the filename. Can be invoked more then once. Example:
#on_stylesheet_saved do |filename|
#  Growl.notify {
#     self.message = "#{File.basename(filename)} updated!"
#     self.icon = '/path/to/success.jpg'
#   }
#end


# Pass this function a block of code that gets executed if a stylesheet has an error while processing. The block will be passed the filename and the error message. Can be invoked more then once. Example:
#on_stylesheet_error do |filename, message|
#  Growl.notify {
#    self.message = "#{File.basename(filename)}: #{message}"
#    self.icon = '/path/to/fail.jpg'
#    sticky!
#  }
#end

$:.push File.expand_path('../../', __FILE__)
require 'fileutils'
require 'flavours'

command :install do |c|
  c.syntax = 'flavours install [options]'
  c.summary = 'Creates the required files in your directory.'
  c.description = ''
  c.option '-d', '--directory DIRECTORY', 'Path where the .xcproj or .xcworkspace file && the longbow.json file live.'

  c.action do |args, options|
    # Check for newer version
    # Longbow::check_for_newer_version unless $nolog

    # Set Up
    @directory = options.directory ? options.directory : Dir.pwd
    @json_path = @directory + '/flavours.json'

    # Install
    if File.exist?(@json_path)
      Flavours::red '  flavours.json already exists at ' + @json_path
    else
      File.open(@json_path, 'w') do |f|
        f.write(Flavours::base_json_file_string)
      end
      Flavours::green '  flavours.json created' unless $nolog
    end
  end
end
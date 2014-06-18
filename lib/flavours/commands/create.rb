$:.push File.expand_path('../../', __FILE__)
require 'fileutils'
require 'flavours/colors'
require 'flavours/images'
require 'flavours/json'
require 'flavours/gradle'
require 'json'

command :create do |c|
  c.syntax = 'flavours create [options]'
  c.summary = 'Creates/updates a target or all targets in your workspace or project.'
  c.description = ''
  c.option '-m', '--module MODULE', 'Name of the module to edit.'
  c.option '-d', '--directory DIRECTORY', 'Path where the module lives.'
  c.option '-u', '--url URL', 'URL of a Flavours formatted JSON file.'

  c.action do |args, options|
    # Check for newer version
    Flavours::check_for_newer_version unless $nolog

    # Set Up
    @module = options.module ? options.module : nil
    @directory = options.directory ? options.directory : Dir.pwd
    @url = options.url ? options.url : nil
    @flavours = []

    # Create JSON object
    if @url
      obj = Flavours::json_object_from_url @url
    else
      obj = Flavours::json_object_from_directory @directory
    end

    # Break if Bad
    unless obj || Flavours::lint_json_object(obj)
      Flavours::red "\n  Invalid JSON. Please lint the file, and try again.\n"
      next
    end


    # Check for Target Name
    if @module
      obj['flavours'].each do |t|
        @flavours << t
      end

      if @flavours.length == 0
        Flavours::red "\n  No flavours found in the flavours.json file.\n"
        next
      end

      # Create Them
      Flavours::create @flavours, @directory, @module
    else
      Flavours::red "\n  Module must be specified using the -m or --module option.\n"
    end
  end
end

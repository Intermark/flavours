$:.push File.expand_path('../', __FILE__)
require 'colors'
require 'open-uri'
require 'json'

module Flavours

  def self.json_object_from_directory directory
    return nil unless directory

    # Check for longbow.json
    @json_path = directory + '/flavours.json'
    unless File.exists?(@json_path)
      Flavours::red "\n  Couldn't find flavours.json at #{@json_path}\n"
      puts "  Run this command to install the correct files:\n  longbow install\n"
      return nil
    end

    # Create hash from longbow.json
    json_contents = File.open(@json_path).read
    return json_object_from_string json_contents
  end


  def self.json_object_from_url url
    return nil unless url
    contents = ''
    open(url) {|io| contents = io.read}
    return json_object_from_string contents
  end


  def self.json_object_from_string contents
    begin
      !!JSON.parse(contents)
    rescue
      return nil
    end

    return JSON.parse(contents)
  end


  def self.lint_json_object obj
    return false unless obj
    return false unless obj['flavours']
    return true
  end


  def self.base_json_file_string
    return '{
	"flavours" : [
		{
      "flavourName" : "YourFlavor",
			"packageName" : "somePackageName",
			"buildConfig" : {
				"API_KEY" : "someApiKey",
				"DEALER_COLOR" : "#E51919"
			},
			"iconUrl" : "https://someurl.com/image.png"
		},
		{
      "flavourName" : "YourFlavor",
			"packageName" : "somePackageName",
			"buildConfig" : {
				"API_KEY" : "someApiKey",
				"DEALER_COLOR" : "#E51919"
			},
			"iconUrl" : "https://someurl.com/image.png"
		}
	]
}'
  end

end
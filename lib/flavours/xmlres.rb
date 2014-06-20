require 'colors'
require 'assets'
require 'open-uri'

module Flavours

  # Create XML
  def self.create_xml_resources directory, m, flavour_hash
    flavour_name = flavour_hash['flavourName']
    flavour_hash.each_pair do |k, v|
      if k == 'colorsXML'
        create_xml_for_hash directory, m, v, 'values', 'colors', 'color', flavour_name
        puts "  - Created colors.xml for #{flavour_name}"
      elsif k == 'stringsXML'
        create_xml_for_hash directory, m, v, 'values', 'strings', 'string', flavour_name
        puts "  - Created strings.xml for #{flavour_name}"
      elsif k == 'settingsXML'
        create_xml_for_hash directory, m, v, 'values', 'settings', 'item', flavour_name
        puts "  - Created settings.xml for #{flavour_name}"
      end
    end
  end

  # Main Method
  def self.create_xml_for_hash directory, m, xml_hash, res_folder_name, res_file_name, res_key_name, flavour_name
    # Create Directory
    Flavours::make_asset_directory directory, m, flavour_name, res_folder_name
    # Set Up
    res_path = Flavours::file_path_with_folder_name(directory, res_folder_name, m, flavour_name) + "/#{res_file_name}.xml"
    xmlString = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n    <resources>\n"
    # Create Strings
    if xml_hash.kind_of?(Array)
      xml_hash.each do |hash|
        xmlString += res_string res_key_name, hash['name'], hash['value'], hash['type']
      end
    else
      xml_hash.each_pair do |k, v|
        xmlString += res_string res_key_name, k, v, nil
      end
    end
    # Finish Her Off
    xmlString += '    </resources>'
    File.open(res_path, 'w') do |f|
      f.write(xmlString)
    end
  end

  # Resource String
  def self.res_string res, name, value, type
    type_string = type ? " type=\"#{type}\"" : ''
    return "        <#{res} name=\"#{name}\"#{type_string}>#{value.sub("'", "\\'")}</#{res}>\n"
  end
end
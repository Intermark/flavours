$:.push File.expand_path('../', __FILE__)
require 'colors'
require 'open-uri'
require 'json'

module Flavours
  def self.create flavours, directory, m
    @flavour_string = ''
    flavours.each do |f|
      @flavour_string += gradle_string_for_flavour f
      Flavours::green "  #{f['flavourName']}" unless $nolog
      Flavours::create_images directory, m, f unless $nolog
      puts
    end

    set_and_save_flavours_text @flavour_string, directory, m
  end

  def self.gradle_directory directory, m
    return directory + '/' + m + '/build.gradle'
  end


  def self.gradle_text directory, m
    path = gradle_directory directory, m
    if File.exists?(path)
      return File.open(path).read
    end

    return nil
  end


  def self.gradle_string_for_flavour flavour
    package = "            packageName \"#{flavour['packageName']}\"\n" unless flavour['packageName'] == nil
    buildConfig = build_config_string_for_flavour flavour
    return "        #{flavour['flavourName']} {\n#{package}#{buildConfig}        }\n"
  end


  def self.build_config_string_for_flavour flavour
    if flavour['buildConfig']
      @buildconfig = ''
      flavour['buildConfig'].each_pair do |k, v|
        @buildconfig += "            buildConfigField \"String\" , \"#{k}\" ,  \"\\\"#{v}\\\"\"\n"
      end
      return @buildconfig
    end

    return ''
  end


  def self.set_and_save_flavours_text flavours_text, directory, m
    @gradle = gradle_text directory, m
    matches = @gradle.match /productFlavors \{(?>[^()]|(\g<0>))*\}\n\n/
    new_flavour_text = "    productFlavors {\n#{flavours_text}    }\n\n"
    if matches
      @gradle = @gradle.sub(matches[0], new_flavour_text)
    else
      @gradle = @gradle.sub('android {',"android {\n#{new_flavour_text}")
    end

    File.open(gradle_directory(directory, m), 'w') do |f|
      f.write(@gradle)
    end
  end

end

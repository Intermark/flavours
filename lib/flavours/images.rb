$:.push File.expand_path('../', __FILE__)
# require 'mini_magick'
require 'RMagick'
include Magick
require 'colors'
require 'open-uri'

module Flavours

  # Images
  def self.create_images directory, m, flavour_hash
    # Bad Params
    if !directory || !flavour_hash || !m
      return false
    end

    # Resize Icons
    resize_icons directory, m, flavour_hash
  end


  # Create & Resize Icons
  def self.resize_icons directory, m, flavour_hash
    # Set Up
    name = flavour_hash['flavourName']

    # Get Image Information
    img_path = ''
    if flavour_hash['iconUrl']
      img_path = self.path_for_downloaded_image_from_url directory, name, flavour_hash['iconUrl'], 'icons'
    end

    # Make Assets Directory
    make_asset_directory directory, m, name

    # Resize
    image_sizes = ['144x144', '96x96', '72x72', '48x48']
    drawables = ['drawable-xxhdpi','drawable-xhdpi','drawable-hdpi','drawable-mdpi']
    image_sizes.each_index do |i|
      size = image_sizes[i]
      drawable = drawables[i]
      img_dir = file_path_with_drawable_name directory, drawable, m, name
      image = Image.read(img_path).first
      next unless image
      resize_image_to_directory img_dir, image, size, 'ic_launcher'
    end

    puts '  - Created Icon images for ' + name unless $nolog
    return true
  end


  # Resize Image to Directory
  def self.resize_image_to_directory directory, image, size, tag
    sizes = size.split('x')
    new_w = Integer(sizes[0])
    new_h = Integer(sizes[1])
    image.resize_to_fill! new_w, new_h
    image.write  directory + '/' + tag + '.png'
  end

  # Download Image from URL
  def self.path_for_downloaded_image_from_url directory, filename, url, folder
    img_path = directory + '/resources/'+ folder + '/'
    img_file_name = filename + '.png'
    FileUtils::mkdir_p img_path
    File.open(img_path + img_file_name, 'wb') do |f|
      f.write open(url).read
    end

    return img_path + img_file_name
  end


  # Asset Directory Methods
  def self.make_asset_directory directory, m, flavour_name
    subfolders = ['drawable-hdpi','drawable-mdpi','drawable-xhdpi','drawable-xxhdpi']
    subfolders.each do |f|
      FileUtils::mkdir_p file_path_with_drawable_name directory, f, m, flavour_name
    end
  end

  def self.assets_file_path directory, m, flavour_name
    return "#{directory}/#{m}/src/#{flavour_name}/res"
  end

  def self.file_path_with_drawable_name directory, name, m, flavour_name
    return "#{assets_file_path directory, m, flavour_name}/#{name}"
  end

end

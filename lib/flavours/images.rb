$:.push File.expand_path('../', __FILE__)
# require 'mini_magick'
require 'RMagick'
include Magick
require 'colors'
require 'assets'
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

    # Move Drawables
    move_drawables directory, m, flavour_hash if flavour_hash['drawables']
  end


  # Create & Resize Icons
  def self.resize_icons directory, m, flavour_hash
    # Set Up
    name = flavour_hash['flavourName']

    # Get Image Information
    img_path = ''
    if flavour_hash['iconUrl']
      img_path = self.path_for_downloaded_image_from_url directory, name, flavour_hash['iconUrl'], 'icons'
    elsif flavour_hash['iconPath']
      img_path = "#{directory}/#{flavour_hash['iconPath']}"
    else
      return
    end

    # Create Play Store Version (512x512)
    play_store_path = "#{directory}/resources/icons"
    img = Image.read(img_path).first
    resize_image_to_directory play_store_path, img, '512x512', "#{name}-512"

    # Make Assets Directory
    drawables = ['drawable-xxxhdpi','drawable-xxhdpi','drawable-xhdpi','drawable-hdpi','drawable-mdpi']
    drawables.each do |d|
      Flavours::make_asset_directory directory, m, name, d
    end

    # Resize
    image_sizes = ['192x192', '144x144', '96x96', '72x72', '48x48']
    image_sizes.each_index do |i|
      size = image_sizes[i]
      drawable = drawables[i]
      img_dir = file_path_with_folder_name directory, drawable, m, name
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


  # Move Drawables
  def self.move_drawables directory, m, flavour_hash
    imgs = flavour_hash['drawables']
    if imgs && imgs.kind_of?(Array)
      imgs.each do |i|
        move_drawable directory, m, flavour_hash, i
      end
    end
  end


  # Move Drawable
  def self.move_drawable directory, m, flavour_hash, i
    # Set Up
    f_name = flavour_hash['flavourName']
    # Make Path
    Flavours::make_asset_directory directory, m, f_name, 'drawable'
    # Find Image
    image = Image.read("#{directory}/#{i['path']}").first
    if image
      image.write "#{Flavours::file_path_with_folder_name(directory, 'drawable', m, f_name)}/#{i['name']}"
    end
  end

end

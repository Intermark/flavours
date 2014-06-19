require 'fileutils'

module Flavours
  def self.make_asset_directory directory, m, flavour_name, folder_name
    FileUtils::mkdir_p file_path_with_folder_name directory, folder_name, m, flavour_name
  end

  def self.assets_file_path directory, m, flavour_name
    return "#{directory}/#{m}/src/#{flavour_name}/res"
  end

  def self.file_path_with_folder_name directory, folder, m, flavour_name
    return "#{assets_file_path directory, m, flavour_name}/#{folder}"
  end
end
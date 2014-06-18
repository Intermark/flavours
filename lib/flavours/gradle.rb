$:.push File.expand_path('../', __FILE__)
require 'colors'
require 'open-uri'
require 'json'

module Flavours
  def self.create flavours
    flavours.each do |f|
      Flavours::green "  Finished: #{f['flavourName']}\n" unless $nolog
    end
  end
end

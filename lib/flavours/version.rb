module Flavours
  VERSION = "0.0.7"

  def self.check_for_newer_version
    unless Gem.latest_version_for('flavours').to_s == VERSION
      Flavours::purple "\n  A newer version of flavours is available. Run '[sudo] gem update flavours'."
    end
  end
end

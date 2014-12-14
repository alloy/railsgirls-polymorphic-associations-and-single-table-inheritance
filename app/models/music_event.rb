class MusicEvent < ActiveRecord::Base
  def description
    "Music: #{band}"
  end
end

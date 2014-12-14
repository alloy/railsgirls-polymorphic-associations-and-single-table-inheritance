class SportEvent < ActiveRecord::Base
  def description
    "#{type.sub('Event', '')}: #{home_team} vs #{away_team}"
  end
end

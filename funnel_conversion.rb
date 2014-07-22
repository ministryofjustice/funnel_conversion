require 'gattica'
require 'nokogiri'

class FunnelEntry
  def initialize entry, goal_id
    @entry = entry
    @goal_id = goal_id
  end

  def value attribute
    @entry.at(%Q|[name="ga:#{attribute}"]|)['value']
  end

  def date
    [ value('year'), value('month'), value('day') ].join('-')
  end

  def conversion_rate
    100.0 - Float(value("goal#{@goal_id}AbandonRate"))
  end

end

class FunnelConversion

  def initialize options
    @ga = Gattica.new({ email:  ENV['email'], password:  ENV['password'] })
    @ga.profile_id = options[:profile_id]
    @goal_id = options[:goal_id]
  end

  def todays_conversion_rate
    today = Date.today.to_s
    data = @ga.get({ start_date:  '2014-07-19', end_date:  '2014-07-20', dimensions:  ['day','month', 'year'], metrics:  ['goal4AbandonRate'], max_results:  25 })
    doc = Nokogiri::XML data.xml
    entry = FunnelEntry.new(doc.at('entry'), @goal_id)
    entry.conversion_rate
  end

end



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

  def data start_date, end_date
    response = @ga.get({ start_date:  start_date, end_date:  end_date, dimensions:  ['day','month', 'year'], metrics:  ["goal#{@goal_id}AbandonRate"] })
    doc = Nokogiri::XML response.xml
  end

  def todays_conversion_rate
    today = Date.today.to_s
    doc = data(today, today)
    entry = FunnelEntry.new(doc.at('entry'), @goal_id)
    entry.conversion_rate
  end

  def last_x_days_completion_rates days
    yesterday = (Date.today - 1).to_s
    start = (Date.today - days).to_s
    doc = data(start, yesterday)
    entries = (doc/'entry').map { |e| FunnelEntry.new(e, @goal_id) }

    entries.map {|e| [e.date, e.conversion_rate] }
  end

end

require 'sinatra/base'
require_relative 'funnel_conversion'

class FunnelConversionRate < Sinatra::Base

  get '/todays_completion_rate/:profile_id/:goal_id' do
    funnel = FunnelConversion.new(profile_id: params[:profile_id], goal_id: params[:goal_id])
    rate = funnel.todays_conversion_rate
    %Q|{
      "item": [
        {
          "text": "#{rate.round(1)}%"
        }
      ]
    }|
  end

  get '/last_x_days_completion_rate/:days/:profile_id/:goal_id' do
    funnel = FunnelConversion.new(profile_id: params[:profile_id], goal_id: params[:goal_id])
    rates = funnel.last_x_days_completion_rates(Integer(params[:days]))
    values = rates.map(&:last)
    average = (values.reduce(:+) / values.size).round(1)
    values = values.map{|v| v.round(1).to_s }
    %Q|{
      "item": [
        {
          "text": "Past #{params[:days]} days",
          "value": "#{average}%"
        },
        #{values}
      ]
    }|
  end

end

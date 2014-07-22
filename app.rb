require 'sinatra/base'
require_relative 'funnel_conversion'

class FunnelConversionRate < Sinatra::Base

  get '/todays_completion_rate/:profile_id/:goal_id' do
    funnel = FunnelConversion.new(profile_id: params[:profile_id], goal_id: params[:goal_id])
    rate = funnel.todays_conversion_rate
    %Q|{
      "item": [
        {
          "text": "#{rate.round(2)}%"
        }
      ]
    }|
  end

end

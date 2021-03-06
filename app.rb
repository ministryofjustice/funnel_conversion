require 'sinatra/base'
require_relative 'funnel_conversion'

class FunnelConversionRate < Sinatra::Base

  get '/todays_completion_rate/:profile_id/:goal_id' do
    rate = funnel.todays_conversion_rate
    %Q|{
      "item": [
        {
          "text": "<div class='main-stat t-size-x60'>#{rate.round(1)}%</div>"
        }
      ]
    }|
  end

  get '/last_x_days_completion_rate/:days/:profile_id/:goal_id' do
    rates = funnel.last_x_days_completion_rates(Integer(params[:days]))
    values = rates.map(&:last)
    average = (values.reduce(:+) / values.size).round(1)
    values = values.map{|v| v.round(1).to_s }
    %Q|{
      "item": [
        {
          "text": "Past #{params[:days]} days",
          "value": "#{average}"
        },
        #{values}
      ]
    }|
  end

  get '/last_x_days_average_session_time/:days/:profile_id/:segment_id' do
    average_session_time params[:segment_id]
  end

  get '/last_x_days_average_session_time/:days/:profile_id' do
    average_session_time nil
  end

  get '/last_x_days_error_exit_counts/:days/:profile_id/:goal_id' do
    counts = funnel.event_exit_counts(Integer(params[:days]))[0..4]
    items = counts.map do |c|
      %Q|{
        "title": {
          "text": "#{c.event_label}"
        },
        "description": "#{c.unique_count} occurrences"
      }|
    end
    %Q|[ #{items.join(",\n")} ]|
  end

  private

  def average_session_time segment_id
    times = funnel.average_time(Integer(params[:days]), segment_id)
    values = times.map(&:last)
    average = (values.reduce(:+) / values.size).round(1)
    values = values.map{|v| v.round(1).to_s }
    %Q|{
      "item": [
        {
          "text": "Past #{params[:days]} days",
          "value": "#{average}"
        },
        #{values}
      ]
    }|
  end

  def funnel
    FunnelConversion.new(profile_id: params[:profile_id], goal_id: params[:goal_id])
  end
end

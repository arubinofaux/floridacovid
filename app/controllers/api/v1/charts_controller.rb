module Api
  module V1
    class ChartsController < ApplicationController
      def cases
        state = State.includes(:state_stats).find_by_slug("florida")
        stats = state.state_stats.all.order("created_at ASC")

        date_from = stats.first.created_at.to_date
        date_to = stats.last.created_at.to_date
        date_range = date_from..date_to
        new_cases = []

        date_range.map {|d| Date.new(d.year, d.month, d.day) }.uniq.each do |d|
          stat = state.state_stats.where(created_at: d.midnight..d.end_of_day).last
          
          if stat
            stat_yesterday = state.state_stats.where(created_at: (stat.created_at - 24.hours).all_day).last
            if stat_yesterday.blank?
              stat_yesterday = stat
            end

            new_cases.push([ d, ((stat.positive_residents + stat.positive_non_residents) - (stat_yesterday.positive_residents + stat_yesterday.positive_non_residents))])
          end
        end

        result = [
          {name: "New Cases", data: new_cases, color: "#f00"}
        ]
        
        render json: result, status: 200
      end
    end
  end
end
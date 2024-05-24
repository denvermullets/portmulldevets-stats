# service that grabs events and organizes it for dashboard charts

module GenerateGraph
  class Dashboard < Service
    def initialize(start_date:, end_date:)
      @start_date = start_date ? Date.parse(start_date) : 30.days.ago.to_date
      @end_date = end_date ? Date.parse(end_date) : Date.today
      @complete_dates = (@start_date..@end_date).to_a
    end

    def call
      events_by_range = Event.where(created_at: @start_date.beginning_of_day..@end_date.end_of_day)

      unique_users = filter_unique_users(events_by_range)
      unique_users_by_day = generate_unique_counts(unique_users)

      events_by_day = events_by_range.group_by_day(:created_at).count
      page_views_by_day = events_by_range.where(tag: 'page_visit').group_by_day(:created_at).count

      {
        unique_users_by_day:, events_by_day:, page_views_by_day:,
        events_by_range: events_by_range.order(created_at: :asc)
      }
    end

    private

    def filter_unique_users(events_by_range)
      # convert :created_at to just the date value and group by [user_id, date]
      # { [1, '2024-05-21'] => [Event 1, Event 2], [2, '2024-05-21'] => [Event 3],
      #  [1, '2024-05-22'] => [Event 4, Event 5, ..] }
      users_by_day = events_by_range.group_by { |event| [event.user_id, event.created_at.to_date] }
      users_by_day.map { |(_, events)| events.first }
    end

    def generate_unique_counts(unique_users)
      # counts unique users per day
      # { '2024-05-19' => [event1], '2024-05-20' => [event2, event3, event4], '2024-05-21' => [event5] }
      # { '2024-05-19' => 1, '2024-05-20' => 3, '2024-05-21' => 1 }
      unique_users_by_date = unique_users.group_by { |event| event.created_at.to_date }
                                         .transform_values { |events| events.map(&:user_id).uniq.count }

      # Fill in missing days with zero counts
      @complete_dates.each_with_object({}) do |date, hash|
        hash[date] = unique_users_by_date[date] || 0
      end
    end
  end
end

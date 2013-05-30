require 'time'

module ESS
  class ESS < Element
    def initialize
      super :ess, DTD::ESS
    end

    def find_coming n=10
      feeds = []
      channel.feed_list.each do |feed|
        feed.dates.item_list.each do |item|
          if item.type_attr == "standalone"
            feeds << { :time => Time.parse(item.start.text!), :feed => feed }
          elsif item.type_attr == "recurrent"
            moments = parse_recurrent_date_item(item)
            moments.sort! { |x, y| x <=> y }
            moments.each do |moment|
              feeds << { :time => moment, :feed => feed }
            end
          else
            raise DTD::InvalidValueError, "the \"#{item.type_attr}\" is not valid for a date item type attribute"
          end
        end
      end
      feeds.sort! { |x, y| x[:time] <=> y[:time] }
      return feeds[0..n-1]
    end

    def find_between start_time, end_time
      feeds = []
      channel.feed_list.each do |feed|
        feed.dates.item_list.each do |item|
          if item.type_attr == "standalone"
            feed_start_time = Time.parse(item.start.text!)
            if feed_start_time.between?(start_time, end_time)
              feeds << { :time => feed_start_time, :feed => feed }
            end
          elsif item.type_attr == "recurrent"
            moments = parse_recurrent_date_item(item)
            moments.each do |moment|
              if moment.between?(start_time, end_time)
                feeds << { :time => moment, :feed => feed }
              end
            end
          else
            raise DTD::InvalidValueError, "the \"#{item.type_attr}\" is not valid for a date item type attribute"
          end
        end
      end
      feeds.sort! { |x, y| x[:time] <=> y[:time] }
    end

    private
   
      def parse_recurrent_date_item item
        first = Time.parse(item.start.text!)
        limit = item.limit_attr.to_i
        all = [first]
        (2..limit).each do |n|
          all << calc_nth_event(n, first, item.unit_attr, item.interval_attr)
        end
        all
      end

      def calc_nth_event n, first, unit, interval
        next_event = first
        interval = 1 if interval.empty?
        repeat = (n-1) * interval.to_i
        case unit
        when "year"
          repeat.times { next_event = inc_year(next_event) }
        when "month"
          repeat.times { next_event = inc_month(next_event) }
        when "week"
          repeat.times { next_event = inc_week(next_event) }
        when "day"
          repeat.times { next_event = inc_day(next_event) }
        when "hour"
          repeat.times { next_event = inc_hour(next_event) }
        else
          raise InvalidValueError, "the \"#{item.unit_attr}\" is not valid for a date item unit attribute"
        end
        return next_event
      end

      def inc_year time
        if time.year % 4 == 0
          time + 60*60*24*366
        else
          time + 60*60*24*365
        end
      end

      def inc_month time
        increment = nil
        if time.month == 2
          if time.year % 4 == 0
            increment = 60*60*24*29
          else
            increment = 60*60*24*28
          end
        elsif [1,3,5,7,8,10,12].include? time.month
          increment = 60*60*24*31
        else
          increment = 60*60*24*30
        end
        fix_for_dst(time, time + increment)
      end

      def inc_week time
        fix_for_dst(time, time + 60*60*24*7)
      end

      def inc_day
        fix_for_dst(time, time + 60*60*24)
      end

      def inc_hour
        kime + 3600
      end

      def fix_for_dst original_time, new_time
        if original_time.hour != new_time.hour
          new_time = new_time + (original_time.hour - new_time.hour) * 3600
        end
        if original_time.min != new_time.min
          new_time = new_time + (original_time.min - new_time.min) * 60
        end
        new_time
      end

  end
end


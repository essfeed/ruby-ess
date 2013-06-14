require 'time'

module ESS
  class ESS < Element
    def initialize
      super :ess, DTD::ESS
    end

    ##
    # Returns the next n events from the moment specified in the second
    # optional argument.
    #
    # === Parameters
    #
    # [n = 10] how many coming events should be returned
    # [start_time] only events hapenning after this time will be considered
    #
    # === Returns
    #
    # A list of hashes, sorted by event start time, each hash having
    # two keys:
    #
    # [:time] start time of the event
    # [:feed] feed describing the event
    #
    def find_coming n=10, start_time=nil
      start_time = Time.now if start_time.nil?
      feeds = []
      channel.feed_list.each do |feed|
        feed.dates.item_list.each do |item|
          if item.type_attr == "standalone"
            feeds << { :time => Time.parse(item.start.text!), :feed => feed }
          elsif item.type_attr == "recurrent"
            moments = parse_recurrent_date_item(item, n, start_time)
            moments.each do |moment|
              feeds << { :time => moment, :feed => feed }
            end
          elsif item.type_attr == "permanent"
            start = Time.parse(item.start.text!)
            if start > start_time
              feeds << { :time => start, :feed => feed }
            else
              feeds << { :time => start_time, :feed => feed }
            end
          else
            raise DTD::InvalidValueError, "the \"#{item.type_attr}\" is not valid for a date item type attribute"
          end
        end
      end
      feeds = feeds.delete_if { |x| x[:time] < start_time }
      feeds.sort! { |x, y| x[:time] <=> y[:time] }
      return feeds[0..n-1]
    end

    ##
    # Returns all events starting after the time specified by the first
    # parameter and before the time specified by the second parameter,
    # which accept regular Time objects.
    #
    # === Parameters
    #
    # [start_time] will return only events starting after this moment
    # [end_time] will return only events starting before this moment
    #
    # === Returns
    #
    # A list of hashes, sorted by event start time, each hash having
    # two keys:
    #
    # [:time] start time of the event
    # [:feed] feed describing the event
    #
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
            moments = parse_recurrent_date_item(item, end_time, start_time)
            moments.each do |moment|
              if moment.between?(start_time, end_time)
                feeds << { :time => moment, :feed => feed }
              end
            end
          elsif item.type_attr == "permanent"
            start = Time.parse(item.start.text!)
            unless start > end_time
              if start > start_time
                feeds << { :time => start, :feed => feed }
              else
                feeds << { :time => start_time, :feed => feed }
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

      WEEK_DAYS = {
        'monday' => 1,
        'tuesday' => 2,
        'wednesday' => 3,
        'thursday' => 4,
        'friday' => 5,
        'saturday' => 6,
        'sunday' => 7
      }

      INC_FUNCS = {
        "year" => lambda { |time| inc_year(time) },
        "month" => lambda { |time| inc_month(time) },
        "week" => lambda { |time| inc_week(time) },
        "day" => lambda { |time| inc_day(time) },
        "hour" => lambda { |time| inc_hour(time) }
      }

      def parse_recurrent_date_item item, n_or_end_date, start_time
        current = first = Time.parse(item.start.text!)
        inc_period_func = INC_FUNCS[item.unit_attr || "hour"]
        interval = (item.interval_attr == "") ? 1 : item.interval_attr.to_i
        all = []
        if item.limit_attr.length == 0
          break_func = (n.class == FixNum) ? lambda { all.length >= n_or_end_date } : lambda { current > n_or_end_date }
          while true
            parse_unit(item, current, all)
            interval.times do current = inc_period_func.call(current) end
            all = all.delete_if { |x| x[:time] < start_time }
            break if break_func.call
          end
        else
          item.limit_attr.to_i.times do
            parse_unit(item, current, all)
            interval.times do current = inc_period_func.call(current) end
          end
        end
        all = all.delete_if { |time| time < start_time || time < first }
      end

      def parse_unit item, current, all
        case item.unit_attr.downcase
        when "year"
          all << current
        when "month"
          weeks = item.selected_week_attr.downcase.split(",")
          days = item.selected_day_attr.downcase.split(",")
          if weeks.any?
            if days.none?
              days = WEEK_DAYS.keys
            end
          end
          if weeks.none?
            if days.any?
              weeks = ["first", "second", "third", "fourth", "last"]
            end
          end
          if days.any?
            days.each do |day|
              if WEEK_DAYS.include? day
                parse_month_week_day(day, current, weeks, all)
              elsif day.to_i.to_s == day
                parse_month_day(day, current, all)
              else
                raise InvalidValueError, "the \"#{day}\" value is not valid for a date item selected_day attribute"
              end
            end
          else
            all << current
          end
        when "week"
          days = item.selected_day_attr.split(",")
          if days.none?
            all << current
          else
            days.each { |day| parse_week_day(day, current, all) }
          end
        when "day"
          all << current
        when "hour"
          all << current
        else
          raise InvalidValueError, "the \"#{item.unit_attr}\" is not valid for a date item unit attribute"
        end
      end

      def parse_month_week_day day, current, weeks, all
        weeks.each do |week|
          case week
          when "first"
            current = change_time(current, :day => 1)
          when "second"
            current = change_time(current, :day => 8)
          when "third"
            current = change_time(current, :day => 15)
          when "fourth"
            current = change_time(current, :day => 22)
          when "last"
            current = change_time(current, :day => (days_in_month(current) - 6))
          else
            raise InvalidValueError, "the \"#{item.unit_attr}\" is not valid for a date item unit attribute"
          end
          all << change_time(current, :day => ((7+ WEEK_DAYS[day] - current.wday) % 7 + current.day))
        end
      end

      def change_time time, options
        sec = options[:sec] || time.sec
        min = options[:min] || time.min
        hour = options[:hour] || time.hour
        day = options[:day] || time.day
        month = options[:month] || time.month
        year = options[:year] || time.year
        time.class.new(year, month, day, hour, min, sec, time.utc_offset)
      end

      def days_in_month time
        self.class.days_in_month time
      end

      def self.days_in_month time
        case time.month
        when 1, 3, 5, 7, 8, 10, 12
          31
        when 2
          if time.year % 4 == 0
            29
          else
            28
          end
        when 4, 6, 9, 11
          30
        end
      end

      def parse_month_day day, current, all
        all << change_time(current, :day => day)
      end

      def parse_week_day day, current, all
        day = day.downcase
        current_wday = current.wday
        current_wday = 7 if current_wday == 0
        if WEEK_DAYS.keys.include? day
          next_day = current.day + WEEK_DAYS[day] - current_wday
        elsif day.to_i.to_s == day
          next_day = current.day + day.to_i - current_wday
        else
          raise InvalidValueError, "the \"#{day}\" value is not valid for a date item selected_day attribute"
        end
        month = current.month
        if next_day > days_in_month(current)
          next_day -= days_in_month(current)
          month += 1
        end
        year = current.year
        if month > 12
          month -= 12
          year += 1
        end
        all << change_time(current, :year => year, :month => month, :day => next_day)
      end

      def self.inc_year time
        if time.year % 4 == 0
          time + 60*60*24*366
        else
          time + 60*60*24*365
        end
      end

      def self.inc_month time
        increment = nil
        if time.month == 2
          if time.year % 4 == 0
            increment = 60*60*24*29
          else
            increment = 60*60*24*28
          end
        else
          increment = 60*60*24*days_in_month(time)
        end
        time + increment
      end

      def self.inc_week time
        time + 60*60*24*7
      end

      def self.inc_day
        time + 60*60*24
      end

      def self.inc_hour
        kime + 3600
      end
  end
end


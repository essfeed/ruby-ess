require 'net/http'
require 'uri'

module ESS
  module Pusher
    DEFAULT_OPTIONS = {
      :aggregators => ["http://api.hypecal.com/v1/ess/validator.json"],
      :data => ""
    }

    def self.push_to_aggregators options={}
      options = DEFAULT_OPTIONS.merge options
      responses = options[:aggregators].map do |aggregator|
        url = URI.parse(aggregator)
        request = Net::HTTP::Post.new(url.path)
        request.form_data = { "feed_file" => options[:data], "output" => "json" }
        request.content_type = 'text/xml'
        response = Net::HTTP.start(url.host, url.port) { |http| http.request(request) }
      end
      return responses
    end

    def self.example_channel
      ess = Maker.make do |ess|
        ess.channel do |channel|
          channel.title "National Stadium Football events"
          channel.link "http://sample.com/feeds/sample.ess"
          channel.id "ESSID:50b4b412-1ad4-a731-1c6a-2523ffa33f81"
          channel.published "2012-12-13T08:29:29Z"
          channel.updated "2012-12-13T18:30:02-08:00"
          channel.generator "ess:ruby:generator:version:0.9"
          channel.rights "Copyright (c) 2013, John Doe"

          channel.add_feed do |feed|
            feed.title "Football match of saturday"
            feed.uri "http://sample.com/events/specific-and-unique-event-page/"
            feed.id "EVENTID:550b55b412-1ad4-a4731-155-2777fa37f866"
            feed.published "2012-12-13T08:29:29Z"
            feed.updated "2012-12-13T18:30:02-0800"
            feed.access "PUBLIC"
            feed.description("Welcome to my first football match event. " +
                             "This football match is very important. " +
                             "Our team is about to go up against our main league competitor.")

            feed.tags do |tags|
              tags.tag "Sport"
              tags.tag "Footbal"
              tags.tag "Soccer"
              tags.tag "Match"
              tags.tag "Game"
              tags.tag "Team Sport"
              tags.tag "Stadium"
            end

            feed.categories.add_item(:type => "competition") do |item|
              item.name "Football"
              item.id "C2AH"
            end

            feed.dates.add_item do |item|
              item.type_attr "recurrent"
              item.unit_attr "week"
              item.limit_attr "4"
              item.selected_day_attr "saturday,sunday"

              item.name "Match Date"
              item.start "2011-12-13T18:30:02Z"
              item.duration "10800"
            end

            feed.places do |places|
              places.add_item(:type => "fixed", :priority => 1) do |item|
                item.name "Football Stade"
                item.latitude "40.71675"
                item.longitude "-74.00674"
                item.address "Ave of Americas, 871"
                item.city "New York"
                item.zip "10001"
                item.state_code "NY"
                item.country_code "US"
              end

              places.add_item(:type => "fixed", :priority => 2) do |item|
                item.name "Match direct on TV"
                item.country_code "US"
                item.medium_name "NBC super channel"
                item.medium_type "television"
              end
            end

            feed.prices do |prices|
              prices.add_item(:type => "standalone", :priority => 2) do |item|
                item.mode_attr "invitation"

                item.name "Free entrance"
                item.value "0"
                item.currency "USD"
              end

              prices.add_item(:type => "recurrent", :priority => 1) do |item|
                item.unit_attr "month"
                item.mode_attr "fixed"
                item.limit_attr "12"

                item.name "Subscribe monthly !"
                item.value "17"
                item.currency "USD"
                item.start "2012-12-13T18:30:02Z"
              end
            end

            feed.media do |media|
              media.add_item(:type => "image", :priority => 1) do |item|
                item.name "Stade image"
                item.uri "http://sample.com/small/image_1.png"
              end

              media.add_item(:type => "video", :priority => 3) do |item|
                item.name "Stade video"
                item.uri "http://sample.com/video/movie.mp4"
              end

              media.add_item(:type => "sound", :priority => 2) do |item|
                item.name "Radio spot"
                item.uri "http://sample.com/video/movie.mp3"
              end

              media.add_item(:type => "website", :priority => 4) do |item|
                item.name "Football Stade website"
                item.uri "http://my-football-website.com"
              end
            end

            feed.people do |people|
              people.add_item(:type => "organizer") do |item|
                item.id "THJP167:8URYRT24:BUEREBK:567TYEFGU:IPAAF"
                item.uri "http://michaeldoe.com"
                item.name "Michael Doe"
                item.firstname "Michael"
                item.lastname "Doe"
                item.organization "Football club association"
                item.address "80, 5th avenue / 45st E - #504"
                item.city "New York"
                item.zip "10001"
                item.state "New York"
                item.state_code "NY"
                item.country "United States of America"
                item.country_code "US"
                item.logo "http://sample.com/logo_120x60.png"
                item.icon "http://sample.com/icon_64x64.png"
                item.email "contact@sample.com"
                item.phone "+001 (646) 234-5566"
              end

              people.add_item(:type => "performer") do |item|
                item.id "FDH56:G497D6:4564DD465:4F6S4S6"
                item.uri "http://janettedoe.com"
                item.name "Janette Doe"
              end

              people.add_item(:type => "attendee") do |item|
                item.name "Attendees information:"
                item.minpeople 0
                item.maxpeople 500
                item.minage 0
                item.restriction "Smoking is not allowed in the stadium"
              end

              people.add_item(:type => "social") do |item|
                item.name "Social network link to share or rate the event."
                item.uri "http://social_network.com/my_events/my_friends/my_notes"
              end

              people.add_item(:type => "author") do |item|
                item.name "Feed Powered by Event Promotion Tool"
                item.uri "http://sample.com/my_events/"
                item.logo "http://sample.com/logo_120x60.png"
                item.icon "http://sample.com/icon_64x64.png"
              end

              people.add_item(:type => "contributor") do |item|
                item.name "Jane Doe"
              end
            end

            feed.relations do |relations|
              relations.add_item(:type => "alternative") do |item|
                item.name "alternative event"
                item.id "EVENTID:50412:1a904:a715731:1cera:25va33"
                item.uri "http://sample.com/feed/event_2.ess"
              end

              relations.add_item(:type => "related") do |item|
                item.name "related event title"
                item.id "EVENTID:50b412:1a35d4:a731:1354c6a:225dg1"
                item.uri "http://sample.com/feed/event_3.ess"
              end

              relations.add_item(:type => "enclosure") do |item|
                item.name "nearby event"
                item.id "EVENTID:50b12:3451d4:34f5a71:1cf6a:2ff81"
                item.uri "http://sample.com/feed/event_5.ess"
              end
            end
          end
        end
      end
    end
  end
end


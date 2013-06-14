module ESS
  module Examples
    ##
    # Example feeds for documentation and testing.
    #

    def self.from_essfeeds_org_home
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
              item.start "2011-12-17T18:30:02Z"
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
                item.email "contact@example.com"
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

    def self.paying_attendees
      ess = Maker.make do |ess|
        ess.channel do |channel|
          channel.title "Studio 54 Events Feed"
          channel.id "ESSID:65ca2c92-2c98-068e-390d-543c376f8e7d"
          channel.link "http://example.com/feed/sample.ess"
          channel.published "2013-06-10T10:55:14Z"

          channel.add_feed do |feed|
            feed.title "Studio 54 Documentary Night Private Event"
            feed.id "EVENTID:4e0ea291-0acc-b222-60bb-dda020ca8664"
            feed.uri "http://studio54.com/events/saturday.html"
            feed.published "2013-04-23T00:25:33+02:00"
            feed.access "PRIVATE"
            feed.description "Get payed to assist to a documentary about the Studio 54"

            feed.categories.add_item :type => "party" do |item|
              item.name "nightclub"
            end

            feed.dates.add_item :type => "standalone" do |item|
              item.name "Only this night"
              item.start "2013-10-25T15:30:00Z"
              item.duration "7200"
            end

            feed.places.add_item :type => "fixed" do |item|
              item.name "Studio 54"
              item.address "254 W 54th St"
              item.city "New York"
              item.country_code "US"
            end

            feed.prices.add_item :type => "standalone", :mode => "renumerated" do |item|
              item.name "Get Paied to Assist to This Documenary"
              item.value 90
              item.currency "USD"
            end
          end
        end
      end
    end

    def self.osteopathy_course
      ess = Maker.make do |ess|
        ess.channel do |channel|
          channel.title "London College of Osteopathy Feeds"
          channel.id "ESSID:65ca2c92-2c98-068e-390d-543c376f8e7d"
          channel.link "http://example.com/feed/sample.ess"
          channel.published "2013-06-10T10:55:14Z"

          channel.add_feed do |feed|
            feed.title "A Twice a Month Intensive Course"
            feed.id "EVENTID:4e0ea291-0acc-b222-60bb-dda020ca8664"
            feed.uri "http://londoncollege.com/events/page.html"
            feed.published "2013-04-23T00:25:33+02:00"
            feed.access "PUBLIC"
            feed.description "Intensive classes  of six  hours each filled with anatomy,\n" +
                             "gerontology, history of osteopathy and physiology"

            feed.categories.add_item :type => "course" do |item|
              item.name "University Course"
            end

            feed.tags do |tags|
              tags.add_tag "Osteopathy"
              tags.add_tag "Physiology"
              tags.add_tag "Anatomy"
              tags.add_tag "Gerontology"
            end

            feed.dates.add_item :type => "recurrent", :unit => "month", :limit => 6, :selected_day => "saturday", :selected_week => "first,last" do |item|
              item.name "Course the first and last Saturdays of every month"
              item.start "2013-10-05T15:30:00Z"
              item.duration "21600"
            end

            feed.places.add_item :type => "fixed" do |item|
              item.name "London College of Osteopathy"
              item.address "380 Wellington St. Tower B, 6th Floor"
              item.city "London"
              item.country_code "GB"
            end
          end
        end
      end
    end

    def self.belfast_festival
      ess = Maker.make do |ess|
        ess.channel do |channel|
          channel.title "Belfast Film Festival Events"
          channel.id "ESSID:65ca2c92-2c98-068e-390d-543c376f8e7d"
          channel.link "http://belfastfilmfestival.org/feed/films.ess"
          channel.published "2013-06-10T10:55:14Z"

          channel.add_feed do |feed|
            feed.title "First Horror Movie"
            feed.id "EVENTID:4e0ea291-0acc-b222-60bb-dda020ca8664"
            feed.uri "http://belfastfilmfestival.org/events/4567FSE/page.html"
            feed.published "2013-04-23T00:25:33+02:00"
            feed.access "PUBLIC"
            feed.description "Description of the first horror movie."

            feed.categories.add_item :type => "festival" do |item|
              item.name "Horror Movie"
              item.id "I10"
            end

            feed.tags do |tags|
              tags.add_tag "Horror"
              tags.add_tag "Movie"
              tags.add_tag "Belfast"
              tags.add_tag "Festival"
            end

            feed.dates.add_item :type => "standalone" do |item|
              item.name "First Representation Date"
              item.start "2013-10-25T15:30:00Z"
              item.duration "7200"
            end

            feed.places.add_item :type => "fixed" do |item|
              item.name "Congress Hall"
              item.address "49 Donegall Place"
              item.city "Belfast"
              item.country_code "GB"
            end

            feed.prices.add_item :type => "standalone", :mode => "fixed" do |item|
              item.name "One Uniq Price"
              item.value 10
              item.currency "GBP"
            end
          end

          channel.add_feed do |feed|
            feed.title "Second Fantastic Movie"
            feed.id "EVENTID:4e0ea291-0acc-b222-60bb-dda020ca8664"
            feed.uri "http://belfastfilmfestival.org/events/45098FSE/page.html"
            feed.published "2013-04-23T00:25:33+02:00"
            feed.access "PUBLIC"
            feed.description "Description of the second fantastic movie."

            feed.categories.add_item :type => "festival" do |item|
              item.name "Mistery Movie"
              item.id "I12"
            end

            feed.tags do |tags|
              tags.add_tag "Fantastic"
              tags.add_tag "Mistery"
              tags.add_tag "Suspense"
              tags.add_tag "Movie"
              tags.add_tag "Belfast"
              tags.add_tag "Festival"
            end

            feed.dates.add_item :type => "standalone" do |item|
              item.name "Second Representation Date"
              item.start "2013-12-25T15:30:00Z"
              item.duration 7200
            end

            feed.places.add_item :type => "fixed" do |item|
              item.name "Hotel Hilton"
              item.address "4 Lanyon Place"
              item.city "Belfast"
              item.country_code "GB"
            end

            feed.prices do |prices|
              prices.add_item :type => "standalone", :mode => "fixed" do |item|
                item.name "Reservation VIP"
                item.value 100
                item.currency "GBP"
              end

              prices.add_item :type => "standalone", :mode => "fixed" do |item|
                item.name "General Price"
                item.value 20
                item.currency "GBP"
              end
            end
          end
        end
      end
    end

    def self.ring_cycle
      ess = Maker.make do |ess|
        ess.channel do |channel|
          channel.title "Series of Ring Cycle Operas events"
          channel.id "ESSID:65ca2c92-2c98-068e-390d-543c376f8e7d"
          channel.link "http://example.com/feed/sample.ess"
          channel.published "2013-06-10T10:55:14Z"

          channel.add_feed do |feed|
            feed.title "Recursive Event Cycle"
            feed.id "EVENTID:4e0ea291-0acc-b222-60bb-dda020ca8664"
            feed.uri "http://opera.com/events/page.html"
            feed.published "2013-04-23T00:25:33+02:00"
            feed.access "PUBLIC"
            feed.description "Description of the Ring Cycle"

            feed.categories.add_item :type => "entertainment" do |item|
              item.name "Opera"
              item.id "P1"
            end

            feed.dates.add_item :type => "recurrent", :unit => "month", :limit => 12, :selected_day => "monday,tuesday,thursday,friday", :selected_week => "last" do |item|
              item.name "6H Opera every last week of every month (monday,tuesday,thursday and friday) for one year"
              item.start "2013-01-25T08:30:00Z"
              item.duration 21600
            end

            feed.places.add_item :type => "fixed" do |item|
              item.name "London College of Osteopathy"
              item.address "380 Wellington St. Tower B, 6th Floor"
              item.city "London"
              item.country_code "GB"
            end

            feed.media do |media|
              media.add_item :type => "image" do |item|
                item.name "Image 01"
                item.uri "http://opera.com/ringcycle/image01.png"
              end

              media.add_item :type => "image" do |item|
                item.name "Image 02"
                item.uri "http://opera.com/ringcycle/image02.png"
              end
            end
          end
        end
      end
    end

  end
end


ruby-ess
========

#### https://github.com/essfeed/rails-ess 
                                                                                    
[![ESS Feed Standard](http://essfeed.org/images/8/87/ESS_logo_32x32.png)](http://essfeed.org/)

Generate ESS XML feeds with Ruby

## Installation

Add this line to your application's Gemfile:

    gem 'ess', '~> 0.9.1'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ess -v 0.9.1

## Usage

Producing your own ESS feeds is easy. Here is an example about how
it's done, with most of the available tags available in ESS:

```ruby

require 'ess'

ess = ESS::Maker.make do |ess|
  ess.channel do |channel|
    channel.title "National Stadium Football events"
    channel.link "http://sample.com/feeds/sample.ess"
    channel.id "ESSID:50b4b412-1ad4-a731-1c6a-2523ffa33f81"
    channel.published "2012-12-13T08:29:29Z"
    channel.updated "2012-12-13T18:30:02-08:00"
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

```

As can be seen, it's a very Builder-like DSL. The result of this code
will be an ESS feed with one item. To get XML from it, the 'to_xml!'
method ca be used.

More information on ESS and what tags and options are available can
be found on http://essfeed.org/ .

### Pushing feeds to aggregators

Once a feed is generated, it can be submitted to an aggregator easily.
To send it to the default aggregator service, which is Hypecal, just
add an option to the 'make' class method:

```ruby

ess = ESS::Maker.make(:push => true) do |ess|

  ...

end

```

Another way to do the same is to first generate the feed and assign
the result to a variable, like 'ess' in previous example, and call its
'push_to_aggregators' method. It accepts the same options and is
useful for example when the feed has to be submitted in a dalayed job.

In a Rails environment, if the feed is generated in response to a
request, providing the request object to the maker method could
provide the aggregator with more useful data:

```ruby

ess = ESS::Maker.make(:request => request) do |ess|

  ...

end

```

Should you want to provide a list of aggregator services yourself, it
can be done with the aggregators option:

```ruby

ess = ESS::Maker.make(:aggregators => ['http://aggregator.example.com/api.json', ...]) do |ess|

  ...

end

```

Another option is to set a new default list of aggregator services
using the ESS::Pusher class:

```ruby

ESS::Pusher.aggregators = ['http://aggregator.example.com/api.json', ...]

```

### Validation

When using the ESS::Maker class, the resulting feed is
validated automatically at the end of the block. That means that
before the block ends, the feed has to have all the mandatory
tags, with valid values. There is however an option to turn that
behavior off, but there should be a good reason to do that.

```ruby

ess = ESS::Maker.make(:validate => false) do |ess|

  ...

end

```

The resulting object accepts the 'valid?' and 'validate' methods. The
former returns true or false, while the later raises an exception with
a message more useful for debugging.

### Working with tags

A tag with text can be specified like this:

```ruby

ess = ESS::Maker.make do |ess|
  ess.channel do |channel|

    channel.title "National Stadium Football events"

    ...

  end
end

```

Each tag accepts method calls coresponding to child tag names. These
methods can accept a string argument, which will become the text of
the child tag, and/or a list of key/value pairs (options), which will
become tag attributes.

If there is also a block, it should expect one parameter which will
be a reference to the child tag.

For the case where a single tag can have multiple child tags with the
same name, the following construct can be used:

```ruby

ess = ESS::Maker.make do |ess|
  ess.channel do |channel|

    channel.add_feed do |feed|

      ...

    end

    channel.add_feed do |another_feed|

      ...

    end

    end
  end
end

```

For every tag 'tag_name' its parent accepts an 'add_tag_name' method,
which accepts the same arguments as a 'tag_name' method.

Attributes have also their own methods for setting them, for example:

```ruby

ess = ESS::Maker.make do |ess|
  ess.lang_attr "zu"

  ...

end

```

Here the 'lang' attribute of the ess tag is set to "zu". And there is
also a 'text!' method, which can be used to set a tags text:

```ruby

ess = ESS::Maker.make do |ess|
  ess.channel do |channel|

    channel.title do |title|
      title.text! "National Stadium Football events"
    end

    ...

  end
end

```

Again, more information on ESS and what tags and options are available
can be found on http://essfeed.org/ .

### Valid tag and attribute values

Pretty much anything can be used as the value for a tag, as long as
it can be converted to a string with #to_s.

Tags that accept date or
time will accept Time objects too, which will be converted to the
corrent format, which is ISO-8601 for ESS. However, if the value is a
string, an attempt will be made to automatically convert the value
to the ISO-8601 format.

### IDs

The channel and feed ID tags can also be
computed automatically, they don't need to be set by hand. They are
automatically calculated and set the first time the TITLE or URI/LINK
tags are changed. Also, instead of using a valid ID value, any string
can be assigned to the ID tag of a channel or feed, and if it doesn't
start with "ESSID:" or "EVENTID:", it will be regenerated using that
string as the key.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# License

(The MIT License)

Copyright (c) 2013 Hypecal

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


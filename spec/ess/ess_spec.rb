require 'spec_helper'

module ESS
  describe "ESS" do
    let(:future_year) { Time.now.year + 2 }

    context 'feed with one item with standalone date' do
      let(:ess) do
        ess = ESS.new
        ess.channel.add_feed do |feed|
          feed.title "Feed 1"
          feed.dates.add_item do |item|
            item.type_attr "standalone"
            item.name "Date 1"
            item.start Time.parse("#{future_year}-01-01T00:00:00Z")
          end
        end
        ess
      end

      describe '#find_coming' do
        it 'should return that one item in an array' do
          feeds = ess.find_coming
          feeds.length.should == 1
          feeds[0][:feed].title.text!.should == "Feed 1"
        end
      end

      describe '#find_between' do
        it 'should return that one item in an array if it\'s between the two moments in time' do
          feeds = ess.find_between(Time.parse("#{future_year-1}-12-31T23:59:00Z"), Time.parse("#{future_year}-01-01T00:01:00Z"))
          feeds.length.should == 1
          feeds[0][:feed].title.text!.should == "Feed 1"
        end

        it 'should return an empty array if the item event is not between the two moments in time' do
          feeds = ess.find_between(Time.parse("#{future_year}-01-01T00:01:00Z"), Time.parse("#{future_year}-01-01T00:03:00Z"))
          feeds.length.should == 0
        end
      end
    end

    context 'ESS channel with two feeds with future standalone dates' do
      let(:ess) do
        ess = ESS.new
        ess.channel.add_feed do |feed|
          feed.title "Feed 1"
          feed.dates.add_item do |item|
            item.type_attr "standalone"
            item.name "Date 1"
            item.start Time.parse("#{future_year}-01-01T00:00:00Z")
          end
        end
        ess.channel.add_feed do |feed|
          feed.title "Feed 2"
          feed.dates.add_item do |item|
            item.type_attr "standalone"
            item.name "Date 1"
            item.start Time.parse("#{future_year}-01-08T00:00:00Z")
          end
        end
        ess
      end

      describe '#find_coming' do
        it 'should return both items in an array if no parameters were specified' do
          feeds = ess.find_coming
          feeds.length.should == 2
          feeds[0][:feed].title.text!.should == "Feed 1"
          feeds[1][:feed].title.text!.should == "Feed 2"
        end

        it 'should return the first feed in an array if passed the number 1' do
          feeds = ess.find_coming(1)
          feeds.length.should == 1
          feeds[0][:feed].title.text!.should == "Feed 1"
        end

        it 'should return both items in an array if passed the number 2' do
          feeds = ess.find_coming(2)
          feeds.length.should == 2
          feeds[0][:feed].title.text!.should == "Feed 1"
          feeds[1][:feed].title.text!.should == "Feed 2"
        end

        it 'should return both items in an array if passed the number 2, sorted by asc. date/time' do
          feeds = ess.channel.feed_list
          tmp1 = feeds[0]
          tmp2 = feeds[1]
          ess.channel.feed_list.clear
          ess.channel.feed_list << tmp2
          ess.channel.feed_list << tmp1
          feeds = ess.find_coming(2)
          feeds.length.should == 2
          feeds[0][:feed].title.text!.should == "Feed 1"
          feeds[1][:feed].title.text!.should == "Feed 2"
        end
        it 'should return both items in an array if passed the number 3' do
          feeds = ess.find_coming(3)
          feeds.length.should == 2
          feeds[0][:feed].title.text!.should == "Feed 1"
          feeds[1][:feed].title.text!.should == "Feed 2"
        end
      end

      describe '#find_between' do
        it 'should return an empty list if none of the events is between two moments in time' do
          feeds = ess.find_between(Time.parse("#{future_year-1}-12-21T23:59:00Z"), Time.parse("#{future_year-1}-12-31T00:01:00Z"))
          feeds.length.should == 0
          feeds = ess.find_between(Time.parse("#{future_year}-01-10T23:59:00Z"), Time.parse("#{future_year}-01-13T00:01:00Z"))
          feeds.length.should == 0
        end

        it 'should return the first feed if it is happening between the two dates' do
          feeds = ess.find_between(Time.parse("#{future_year-1}-12-21T23:59:00Z"), Time.parse("#{future_year}-01-05T00:01:00Z"))
          feeds.length.should == 1
          feeds[0][:feed].title.text!.should == "Feed 1"
        end

        it 'should return the second feed if it is happening between the two dates' do
          feeds = ess.find_between(Time.parse("#{future_year}-01-01T00:02:00Z"), Time.parse("#{future_year}-01-09T00:01:00Z"))
          feeds.length.should == 1
          feeds[0][:feed].title.text!.should == "Feed 2"
        end

        it 'should return both items if they both happen in the interval' do
          feeds = ess.find_between(Time.parse("#{future_year}-01-01T00:00:00Z"), Time.parse("#{future_year}-01-09T00:01:00Z"))
          feeds.length.should == 2
          feeds[0][:feed].title.text!.should == "Feed 1"
          feeds[1][:feed].title.text!.should == "Feed 2"
        end
      end
    end

    context 'one feed with two date items with standalone values' do
      let(:ess) do
        ess = ESS.new
        ess.channel.add_feed do |feed|
          feed.title "Feed 1"
          feed.dates.add_item do |item|
            item.type_attr "standalone"
            item.name "Date 2"
            item.start Time.parse("#{future_year}-01-01T00:15:00Z")
          end
          feed.dates.add_item do |item|
            item.type_attr "standalone"
            item.name "Date 1"
            item.start Time.parse("#{future_year}-01-01T00:00:00Z")
          end
        end
        ess
      end

      describe "#find_coming" do
        it 'should return two items in a list, if no arguments are passed' do
          ess.find_coming.length.should == 2
        end

        it 'should return one item in a list, if the only argument is a 1' do
          ess.find_coming(1).length.should == 1
        end

        it 'should return a list of dicts, with keys :time and :feed' do
          feeds = ess.find_coming
          feeds.each do |feed|
            feed[:time].should_not be_nil
            feed[:feed].should_not be_nil
          end
        end

        it 'should return a list of discts sorted by ascending order of time' do
          feeds = ess.find_coming
          feeds[0][:time].should == Time.parse("#{future_year}-01-01T00:00:00Z")
          feeds[0][:feed].title.text!.should == "Feed 1"
          feeds[1][:time].should == Time.parse("#{future_year}-01-01T00:15:00Z")
          feeds[1][:feed].title.text!.should == "Feed 1"
        end
      end

      describe "#find_between" do
        it 'should return two items in a list, if both date items are within the time period' do
          feeds = ess.find_between(Time.parse("#{future_year}-01-01T00:00:00Z"), Time.parse("#{future_year}-01-09T00:01:00Z"))
          feeds.length == 2
        end

        it 'should return two hashes in a list, with :time and :feed values defined' do
          feeds = ess.find_between(Time.parse("#{future_year}-01-01T00:00:00Z"), Time.parse("#{future_year}-01-09T00:01:00Z"))
          feeds.each do |feed|
            feed[:time].should_not be_nil
            feed[:feed].should_not be_nil
          end
        end

        it 'should return a list of dicts sorted by ascending order of time' do
          feeds = ess.find_coming
          feeds[0][:time].should == Time.parse("#{future_year}-01-01T00:00:00Z")
          feeds[0][:feed].title.text!.should == "Feed 1"
          feeds[1][:time].should == Time.parse("#{future_year}-01-01T00:15:00Z")
          feeds[1][:feed].title.text!.should == "Feed 1"
        end
      end
    end

    context 'feed with one item with recurring date with a limit attribute' do
      let(:ess) do
        ess = ESS.new
        ess.channel.add_feed do |feed|
          feed.title "Feed 1"
          feed.dates.add_item do |item|
            item.type_attr "recurrent"
            item.unit_attr "month"
            item.limit_attr "5"
            item.name "Date 1"
            item.start Time.parse("#{future_year}-01-01T00:00:00Z")
          end
        end
        ess
      end

      describe "#find_coming" do
        it 'should return the array with as much elements, as there will be separate events' do
          ess.find_coming.length.should == 5
        end

        it 'should return a list of feeds, sorted by starting date/time' do
          feeds = ess.find_coming
          feeds[0][:time].should == Time.parse("#{future_year}-01-01T00:00:00Z")
          feeds[1][:time].should == Time.parse("#{future_year}-02-01T00:00:00Z")
          feeds[2][:time].should == Time.parse("#{future_year}-03-01T00:00:00Z")
          feeds[3][:time].should == Time.parse("#{future_year}-04-01T00:00:00Z")
          feeds[4][:time].should == Time.parse("#{future_year}-05-01T00:00:00Z")
        end
      end

      describe "#find_coming" do
        it 'should return a list of event instances within time boundaries' do
          feeds = ess.find_between(Time.parse("#{future_year}-02-11T00:00:00Z"), Time.parse("#{future_year}-07-11T12:00:00Z"))
          feeds.length.should == 3
          feeds[0][:time].should == Time.parse("#{future_year}-03-01T00:00:00Z")
          feeds[1][:time].should == Time.parse("#{future_year}-04-01T00:00:00Z")
          feeds[2][:time].should == Time.parse("#{future_year}-05-01T00:00:00Z")
        end
      end
    end

    context 'feed with one item with recurring date with a limit attribute and an interval attribute' do
      let(:ess) do
        ess = ESS.new
        ess.channel.add_feed do |feed|
          feed.title "Feed 1"
          feed.dates.add_item do |item|
            item.type_attr "recurrent"
            item.unit_attr "month"
            item.interval_attr "2"
            item.limit_attr "5"
            item.name "Date 1"
            item.start Time.parse("#{future_year}-01-01T00:00:00Z")
          end
        end
        ess
      end

      describe "#find_coming" do
        it 'should return the array with as much elements, as there will be separate events' do
          ess.find_coming.length.should == 5
        end

        it 'should return a list of feeds, sorted by starting date/time' do
          feeds = ess.find_coming
          feeds[0][:time].should == Time.parse("#{future_year}-01-01T00:00:00Z")
          feeds[1][:time].should == Time.parse("#{future_year}-03-01T00:00:00Z")
          feeds[2][:time].should == Time.parse("#{future_year}-05-01T00:00:00Z")
          feeds[3][:time].should == Time.parse("#{future_year}-07-01T00:00:00Z")
          feeds[4][:time].should == Time.parse("#{future_year}-09-01T00:00:00Z")
        end
      end

      describe "#find_between" do
        it 'should return a list of feeds between the two dates it received as parameters' do
          feeds = ess.find_between(Time.parse("#{future_year}-03-11T00:00:00Z"), Time.parse("#{future_year}-10-11T00:00:00Z"))
          feeds.length.should == 3
          feeds[0][:time].should == Time.parse("#{future_year}-05-01T00:00:00Z")
          feeds[1][:time].should == Time.parse("#{future_year}-07-01T00:00:00Z")
          feeds[2][:time].should == Time.parse("#{future_year}-09-01T00:00:00Z")
        end
      end
    end

    context 'feed with one item with recurring date with a limit attribute and a selected_day attribute' do
      let(:ess) do
        ess = ESS.new
        ess.channel.add_feed do |feed|
          feed.title "Feed 1"
          feed.dates.add_item do |item|
            item.type_attr "recurrent"
            item.unit_attr "month"
            item.limit_attr "5"
            item.selected_day_attr "2"
            item.name "Date 1"
            item.start Time.parse("#{future_year}-01-02T00:00:00Z")
          end
        end
        ess
      end

      describe "#find_coming" do
        it 'should return events only on those days specified in the selected_day attribute' do
          feeds = ess.find_coming
          feeds.length.should == 5
          feeds[0][:time].should == Time.parse("#{future_year}-01-02T00:00:00Z")
          feeds[1][:time].should == Time.parse("#{future_year}-02-02T00:00:00Z")
          feeds[2][:time].should == Time.parse("#{future_year}-03-02T00:00:00Z")
          feeds[3][:time].should == Time.parse("#{future_year}-04-02T00:00:00Z")
          feeds[4][:time].should == Time.parse("#{future_year}-05-02T00:00:00Z")
        end

        it 'should support using day names' do
          ess.channel.feed.dates.item.selected_day_attr "monday"
          feeds = ess.find_coming(30)
          feeds.length.should be > 19
          feeds.length.should be < 26
          feeds.each do |event|
            event[:time].wday.should == 1
          end
        end
      end

      describe "#find_between" do
        it 'should return events only on those days specified in the selected_day attribute' do
          feeds = ess.find_between(Time.parse("#{future_year}-01-05 00:00"), Time.parse("#{future_year}-04-06T00:00:00Z"))
          feeds.length.should == 3
          feeds[0][:time].should == Time.parse("#{future_year}-02-02T00:00:00Z")
          feeds[1][:time].should == Time.parse("#{future_year}-03-02T00:00:00Z")
          feeds[2][:time].should == Time.parse("#{future_year}-04-02T00:00:00Z")
        end

        it 'should support using day names' do
          ess.channel.feed.dates.item.selected_day_attr "monday"
          feeds = ess.find_between(Time.parse("#{future_year}-02-01T00:00:00Z"), Time.parse("#{future_year}-04-30T00:00:00Z"))
          feeds.length.should be > 11
          feeds.length.should be < 16
          feeds.each do |event|
            event[:time].wday.should == 1
          end
        end
      end
    end
  end
end


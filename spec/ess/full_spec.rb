require 'spec_helper'
require 'time'

module ESS
  describe "Big examples" do
    describe "Examples::from_essfeeds_org_home" do
      let(:ess) { Examples::from_essfeeds_org_home }
      it 'should be a valid ESS feed' do
        lambda {
          ess.push_to_aggregators
        }.should_not raise_error
      end

      describe '#find_coming' do
        it 'should interpret it correctly' do
          events = ess.find_coming(10, Time.parse("2011-12-10T18:30:02Z"))
          events.length.should == 8
          events[0][:time].should == Time.parse("2011-12-17T18:30:02Z")
          events[1][:time].should == Time.parse("2011-12-18T18:30:02Z")
          events[2][:time].should == Time.parse("2011-12-24T18:30:02Z")
          events[3][:time].should == Time.parse("2011-12-25T18:30:02Z")
          events[4][:time].should == Time.parse("2011-12-31T18:30:02Z")
          events[5][:time].should == Time.parse("2012-01-01T18:30:02Z")
          events[6][:time].should == Time.parse("2012-01-07T18:30:02Z")
          events[7][:time].should == Time.parse("2012-01-08T18:30:02Z")

          events = ess.find_coming(10, Time.parse("2011-12-26T18:30:02Z"))
          events.length.should == 4
          events[0][:time].should == Time.parse("2011-12-31T18:30:02Z")
          events[1][:time].should == Time.parse("2012-01-01T18:30:02Z")
          events[2][:time].should == Time.parse("2012-01-07T18:30:02Z")
          events[3][:time].should == Time.parse("2012-01-08T18:30:02Z")

          events = ess.find_coming(10, Time.parse("2012-12-26T18:30:02Z"))
          events.should be_empty
        end
      end

      describe '#find_between' do
        it 'should interpret it correctly' do
          events = ess.find_between(Time.parse("2011-12-10T18:30:02Z"),
                                    Time.parse("2012-02-08T18:30:02Z"))
          events.length.should == 8
          events[0][:time].should == Time.parse("2011-12-17T18:30:02Z")
          events[1][:time].should == Time.parse("2011-12-18T18:30:02Z")
          events[6][:time].should == Time.parse("2012-01-07T18:30:02Z")
          events[7][:time].should == Time.parse("2012-01-08T18:30:02Z")

          events = ess.find_between(Time.parse("2011-12-10T18:30:02Z"),
                                    Time.parse("2012-01-01T18:30:02Z"))
          events.length.should == 6
          events[5][:time].should == Time.parse("2012-01-01T18:30:02Z")

          events = ess.find_between(Time.parse("2012-12-10T18:30:02Z"),
                                    Time.parse("2013-01-01T18:30:02Z"))
          events.should be_empty
        end
      end
    end

    describe "Examples::paying_attendees" do
      let(:ess) { Examples::paying_attendees }

      it 'should be a valid ESS feed' do
        lambda {
          ess.push_to_aggregators
        }.should_not raise_error
      end

      describe '#find_coming' do
        it 'should interpret it correctly' do
          events = ess.find_coming(10, Time.parse("2011-12-10T18:30:02Z"))
          events.length.should == 1
          events[0][:time].should == Time.parse("2013-10-25T15:30:00Z")

          events = ess.find_coming(10, Time.parse("2013-12-10T18:30:02Z"))
          events.should be_empty
        end
      end

      describe '#find_between' do
        it 'should interpret it correctly' do
          events = ess.find_between(Time.parse("2011-12-10T18:30:02Z"),
                                    Time.parse("2013-12-08T18:30:02Z"))
          events.length.should == 1
          events[0][:time].should == Time.parse("2013-10-25T15:30:00Z")

          events = ess.find_between(Time.parse("2011-12-10T18:30:02Z"),
                                    Time.parse("2012-12-08T18:30:02Z"))
          events.should be_empty

          events = ess.find_between(Time.parse("2013-12-10T18:30:02Z"),
                                    Time.parse("2014-12-08T18:30:02Z"))
          events.should be_empty
        end
      end
    end

    describe "Examples::osteopathy_course" do
      let(:ess) { Examples::osteopathy_course }

      it 'should be a valid ESS feed' do
        lambda {
          ess.push_to_aggregators
        }.should_not raise_error
      end

      describe '#find_coming' do
        it 'should interpret it correctly' do
          events = ess.find_coming(10, Time.parse("2011-12-10T18:30:02Z"))
          events.length.should == 10
          events[0][:time].should == Time.parse("2013-10-05T15:30:00Z")
          events[1][:time].should == Time.parse("2013-10-26T15:30:00Z")
          events[9][:time].should == Time.parse("2014-02-22T15:30:00Z")

          events = ess.find_coming(20, Time.parse("2011-12-10T18:30:02Z"))
          events.length.should == 12
          events[0][:time].should == Time.parse("2013-10-05T15:30:00Z")
          events[1][:time].should == Time.parse("2013-10-26T15:30:00Z")
          events[9][:time].should == Time.parse("2014-02-22T15:30:00Z")
          events[11][:time].should == Time.parse("2014-03-29T15:30:00Z")

          events = ess.find_coming(20, Time.parse("2014-03-10T18:30:02Z"))
          events.length.should == 1
          events[0][:time].should == Time.parse("2014-03-29T15:30:00Z")
        end
      end

      describe '#find_between' do
        it 'should interpret it correctly' do
          events = ess.find_between(Time.parse("2011-12-10T18:30:02Z"),
                                    Time.parse("2013-12-15T18:30:02Z"))
          events.length.should == 5
          events[0][:time].should == Time.parse("2013-10-05T15:30:00Z")
          events[4][:time].should == Time.parse("2013-12-07T15:30:00Z")

          events = ess.find_between(Time.parse("2014-12-10T18:30:02Z"),
                                    Time.parse("2014-12-15T18:30:02Z"))
          events.should be_empty
        end
      end
    end

    describe "Examples::belfast_festival" do
      let(:ess) { Examples::belfast_festival }

      it 'should be a valid ESS feed' do
        lambda {
          ess.push_to_aggregators
        }.should_not raise_error
      end

      describe '#find_coming' do
        it 'should interpret it correctly' do
          events = ess.find_coming(10, Time.parse("2011-12-10T18:30:02Z"))
          events.length.should == 2
          events[0][:time].should == Time.parse("2013-10-25T15:30:00Z")
          events[0][:feed].should == ess.channel.feed_list[0]
          events[1][:time].should == Time.parse("2013-12-25T15:30:00Z")
          events[1][:feed].should == ess.channel.feed_list[1]
          events[0][:feed].should_not == events[1][:feed]

          events = ess.find_coming(10, Time.parse("2013-11-10T18:30:02Z"))
          events.length.should == 1
          events[0][:time].should == Time.parse("2013-12-25T15:30:00Z")

          events = ess.find_coming(10, Time.parse("2014-01-10T18:30:02Z"))
          events.should be_empty
        end
      end

      describe '#find_between' do
        it 'should interpret it correctly' do
          events = ess.find_between(Time.parse("2011-12-10T18:30:02Z"),
                                    Time.parse("2013-12-15T18:30:02Z"))
          events.length.should == 1
          events[0][:time].should == Time.parse("2013-10-25T15:30:00Z")
          events[0][:feed].should == ess.channel.feed_list[0]

          events = ess.find_between(Time.parse("2011-12-10T18:30:02Z"),
                                    Time.parse("2014-12-15T18:30:02Z"))
          events.length.should == 2
          events[0][:time].should == Time.parse("2013-10-25T15:30:00Z")
          events[1][:time].should == Time.parse("2013-12-25T15:30:00Z")
        end
      end
    end

    describe "Examples::ring_cycle" do
      let(:ess) { Examples::ring_cycle }

      it 'should be a valid ESS feed' do
        lambda {
          ess.push_to_aggregators
        }.should_not raise_error
      end

      describe '#find_coming' do
        it 'should interpret it correctly' do
          events = ess.find_coming(50, Time.parse("2011-12-10T18:30:02Z"))
          events.length.should == 48
          events[0][:time].should == Time.parse("2013-01-25T08:30:00Z")
          events[1][:time].should == Time.parse("2013-01-28T08:30:00Z")
          events[47][:time].should == Time.parse("2013-12-31T08:30:00Z")
        end
      end

      describe '#find_between' do
        it 'should interpret it correctly' do
          events = ess.find_between(Time.parse("2011-12-10T18:30:02Z"),
                                    Time.parse("2014-12-15T18:30:02Z"))
          events.length.should == 48
          events[0][:time].should == Time.parse("2013-01-25T08:30:00Z")
          events[1][:time].should == Time.parse("2013-01-28T08:30:00Z")
          events[47][:time].should == Time.parse("2013-12-31T08:30:00Z")

          events = ess.find_between(Time.parse("2014-12-10T18:30:02Z"),
                                    Time.parse("2015-12-15T18:30:02Z"))
          events.should be_empty
        end
      end
    end

  end
end


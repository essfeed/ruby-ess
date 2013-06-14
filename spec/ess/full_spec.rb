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
        end
      end
    end

    describe "Examples::paying_attendees" do
      it 'should be a valid ESS feed' do
        lambda {
          Examples::paying_attendees.push_to_aggregators
        }.should_not raise_error
      end
    end

    describe "Examples::osteopathy_course" do
      it 'should be a valid ESS feed' do
        lambda {
          Examples::osteopathy_course.push_to_aggregators
        }.should_not raise_error
      end
    end

    describe "Examples::belfast_festival" do
      it 'should be a valid ESS feed' do
        lambda {
          Examples::belfast_festival.push_to_aggregators
        }.should_not raise_error
      end
    end

    describe "Examples::ring_cycle" do
      it 'should be a valid ESS feed' do
        lambda {
          Examples::ring_cycle.push_to_aggregators
        }.should_not raise_error
      end
    end

  end
end


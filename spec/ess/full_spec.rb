require 'spec_helper'

module ESS
  describe "Big examples" do
    describe "Examples::from_essfeeds_org_home" do
      it 'should be a valid ESS feed' do
        lambda {
          Examples::from_essfeeds_org_home.push_to_aggregators
        }.should_not raise_error
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


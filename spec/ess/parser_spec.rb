require "spec_helper"

module ESS
  describe Parser do
    describe '.parse' do
      context 'when passed a valid ESS document' do
        let(:doc) { Examples.from_essfeeds_org_home.to_xml! }
        let(:ess) { Parser.parse doc }

        it 'should return an "ess" element object' do
          ess = Parser.parse doc
          ess.name!.should == :ess
        end

        it 'should parse the ess elements children - channel' do
          ess.channel_list.should_not be_empty
        end

        it 'should parse also the channel\'s children elements' do
          ess.channel.title_list.should_not be_empty
          ess.channel.link_list.should_not be_empty
        end

        it 'should parse also the channel\'s children\' children elements' do
          ess.channel.feed_list.should_not be_empty
          ess.channel.feed_list[0].title_list.should_not be_empty
        end

        it 'should parse childrens text' do
          ess.channel.feed_list[0].title.text!.should == "Football match of saturday"
        end

        it 'should parse ess attributes' do
          ess.xmlns_attr.should == "http://essfeed.org/history/0.9"
        end

        it 'should parse ess children\'s attributes' do
          ess.channel.feed.dates.item.type_attr.should == "recurrent"
        end

        it 'should return a valid ESS feed' do
          lambda {
            ess.validate
          }.should_not raise_error
        end
      end

      context 'when passed an invalid ESS document' do
        it 'should raise an exception' do
          expect {
            Parser.parse "hello"
          }.to raise_error(ArgumentError)
        end
      end
    end
  end
end


module ESS
  describe Maker do
    describe '.make' do
      it 'should accept a block and pass it one parameter - a Channel element' do
        channel_place_holder = nil
        Maker.make(:validate => false) { |channel| channel_place_holder = channel }
        channel_place_holder.class.should == Channel
      end

      it 'should return the channel element built in the block' do
        channel_place_holder = nil
        channel = Maker.make(:validate => false) { |channel| channel_place_holder = channel }
        channel_place_holder.object_id.should == channel.object_id
      end

      it 'should accept a version argument, ignoring it for now' do
        Maker.make(:version => "0.9", :validate => false) { |channel| channel }
      end

      it 'should raise an error if the channel is not valid at exit' do
        expect {
          Maker.make { |channel| channel.title "A title" }
        }.to raise_error
      end
    end
  end
end


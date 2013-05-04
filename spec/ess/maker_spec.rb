module ESS
  describe Maker do
    describe '.make' do
      it 'should accept a block and pass it one parameter - a Channel element' do
        channel_place_holder = nil
        Maker.make { |channel| channel_place_holder = channel }
        channel_place_holder.class.should == Channel
      end

      it 'should return the channel element built in the block' do
        channel_place_holder = nil
        channel = Maker.make { |channel| channel_place_holder = channel }
        channel_place_holder.object_id.should == channel.object_id
      end

      it 'should accept a version argument, ignoring it for now' do
        Maker.make("0.9") { |channel| channel }
      end
    end
  end
end


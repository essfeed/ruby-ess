module ESS
  describe Maker do
    describe '.make' do
      it 'should accept a block and pass it one parameter - a ESS element' do
        ess_place_holder = nil
        Maker.make(:validate => false) { |ess| ess_place_holder = ess }
        ess_place_holder.class.should == ESS
      end

      it 'should return the ess element built in the block' do
        ess_place_holder = nil
        ess = Maker.make(:validate => false) { |ess| ess_place_holder = ess }
        ess_place_holder.object_id.should == ess.object_id
      end

      it 'should accept a version argument, ignoring it for now' do
        Maker.make(:version => "0.9", :validate => false) { |ess| ess }
      end

      it 'should raise an error if the channel is not valid at exit' do
        expect {
          Maker.make { |ess| ess.channel.title "A title" }
        }.to raise_error
      end
    end
  end
end


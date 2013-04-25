require 'spec_helper'

module ESS
  describe Channel do
    context "when it is a new channel" do

      let(:channel) { Channel.new }
      it "should not be valid" do
        channel.should_not be_valid
      end
      
      it "should respond when asked for a title" do channel.should respond_to(:title) end
      it "should allow setting the channel title" do channel.should respond_to(:title=) end

      it "should respond when asked for link" do channel.should respond_to(:link) end
      it "should allow setting the channel link" do channel.should respond_to(:link=) end
    end
  end
end


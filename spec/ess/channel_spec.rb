require 'spec_helper'

module ESS
  describe Channel do
    let(:channel) { Channel.new }

    it 'allows setting of title' do
      channel.should respond_to(:title=)
    end

    context 'a new channel' do
      it 'should not be valid' do
        channel.should_not be_valid
      end
    end

    describe '#title=' do
      it 'should accept a string' do
        lambda { channel.title = "An example title" }.should_not raise_error
      end

      it 'should accept an element object' do
        lambda { channel.title = Element.new }.should_not raise_error
      end

      it 'should not allow anything else beside strings and Elements' do
        expect { channel.title = [] }.to raise_error(TypeError)
      end
    end

    describe '#title' do
      it 'should return nil if no title was specified' do
        channel.title.should be_nil
      end

      context 'when title was already set' do
        before(:each) { channel.title = "An example title" }

        it 'should return an instance of Element' do
          channel.title.should be_an_instance_of(Element)
        end

        it 'should return an instance of Element with the message in text' do
          channel.title.text.should == "An example title"
        end
      end
    end
  end
end


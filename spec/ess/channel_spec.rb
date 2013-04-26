require 'spec_helper'

module ESS
  describe Channel do
    let(:channel) { Channel.new }

    context 'a new channel' do
      it 'should not be valid' do
        channel.should_not be_valid
      end
    end

    [:title, :link, :id, :published, :updated, :generator, :rights, :feed].each do |element_name|
      describe "##{element_name}=" do
        let(:writer_method) { "#{element_name}=".to_sym }

        it 'should accept a string' do
          lambda { channel.send(writer_method, "Some text") }.should_not raise_error
        end

        it 'should accept an element object' do
          lambda { channel.send(writer_method, Element.new) }.should_not raise_error
        end

        it 'should not allow anything else beside strings and Elements' do
          expect { channel.send(writer_method, []) }.to raise_error(TypeError)
        end
      end

      describe "##{element_name}" do
        it 'should return nil if the element was not set' do
          channel.send(element_name).should be_nil
        end

        context "when #{element_name} was already set" do
          before(:each) { channel.send("#{element_name}=".to_sym, "Some text") }

          it 'should return an instance of Element' do
            channel.send(element_name).should be_an_instance_of(Element)
          end

          it 'should return an instance of Element with the message in text' do
            channel.send(element_name).text.should == "Some text"
          end
        end
      end
    end
  end
end


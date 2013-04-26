require 'spec_helper'

module ESS
  describe Feed do
    let(:feed) { Feed.new }

    [:title, :id, :access, :description, :published, :uri, :updated, :tags].each do |element_name|
      describe "##{element_name}=" do
        let(:writer_method) { "#{element_name}=".to_sym }

        it 'should accept a string' do
          lambda { feed.send(writer_method, "Some text") }.should_not raise_error
        end

        it 'should accept an element object' do
          lambda { feed.send(writer_method, Element.new) }.should_not raise_error
        end

        it 'should not allow anything else beside strings and Elements' do
          expect { feed.send(writer_method, []) }.to raise_error(TypeError)
        end
      end

      describe "##{element_name}" do
        it 'should return nil if the element was not set' do
          feed.send(element_name).should be_nil
        end

        context "when #{element_name} was already set" do
          before(:each) { feed.send("#{element_name}=".to_sym, "Some text") }

          it 'should return an instance of Element' do
            feed.send(element_name).should be_an_instance_of(Element)
          end

          it 'should return an instance of Element with the message in text' do
            feed.send(element_name).text.should == "Some text"
          end
        end
      end
    end
  end
end


require 'spec_helper'

module ESS
  describe Element do

    let(:element) { Element.new }

    it 'should allow setting of text' do
      element.should respond_to(:text=)
    end

    it 'should have a text method' do
      element.should respond_to(:text)
    end

    it 'should allow setting of text using new' do
      lambda { Element.new "Some text" }.should_not raise_error
      Element.new("Some text").text.should == "Some text"
    end

    describe '#text=' do
      it 'should allow string arguments' do
        lambda { element.text = "Some text" }.should_not raise_error
      end

      it 'should not allow objects except for strings' do
        expect { element.text = [] }.to raise_error(TypeError)
      end
    end

    describe '#text' do
      context 'when no text was set' do
        it 'should return an empty string' do
          element.text.class.should == String
          element.text.should == ''
        end
      end
      context 'when text was set' do
        it 'should return that text' do
          element.text = "Some text"
          element.text.should == "Some text"
        end
      end
    end
  end
end


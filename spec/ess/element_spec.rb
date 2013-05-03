require 'spec_helper'

module ESS
  describe Element do

    describe '#new' do
      it 'should require a DTD argument' do
        expect { Element.new }.to raise_error
      end

      it 'should require that the DTD argument have "attributes" and "tags" keys' do
        expect { Element.new({}) }.to raise_error
        expect { Element.new({:attributes => ""}) }.to raise_error
        expect { Element.new({:tags => ""}) }.to raise_error
      end

      it 'should accept a hash with both :attributes and :tags keys' do
        lambda {
          Element.new({:attributes => "", :tags => ""})
        }.should_not raise_error
      end
    end

    describe '#text' do
      let(:element) { Element.new({:attributes => "", :tags => ""}) }

      context 'when text was not preset' do
        context 'without parameters' do
          it 'should return an empty string' do
            element.text.should == ""
          end
        end
        context 'with parameters' do
          it 'should accept one parameter' do
            lambda {
              element.text("Example text")
            }.should_not raise_error
          end

          it 'should accept only strings' do
            expect { element.text({}) }.to raise_error
          end

          it 'should set the text value of the element to that parameter' do
            element.text "Example text"
            element.text.should == "Example text"
          end
        end
      end

      context 'when text was preset' do
        before(:each) { element.text "Example text" }

        context 'without parameters' do
          it 'should return that text' do
            element.text.should == "Example text"
          end
        end
        context 'with parameters' do
          it 'should accept one parameter' do
            lambda {
              element.text("Example text")
            }.should_not raise_error
          end

          it 'should accept only strings' do
            expect { element.text({}) }.to raise_error
          end

          it 'should set the text value of the element to that parameter' do
            element.text "Example text"
            element.text.should == "Example text"
          end
        end
      end
    end

  end
end


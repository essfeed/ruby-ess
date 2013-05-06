require 'time'
require 'spec_helper'
require 'ess/helpers'

module ESS
  describe Element do

    describe '#new' do
      it 'should require a name and a DTD argument' do
        expect { Element.new }.to raise_error
        expect { Element.new :tag_name }.to raise_error
      end

      it 'should require that the DTD argument have "attributes" and "tags" keys' do
        expect { Element.new(:tag_name, {}) }.to raise_error
        expect { Element.new(:tag_name, {:attributes => ""}) }.to raise_error
        expect { Element.new(:tag_name, {:tags => ""}) }.to raise_error
      end

      it 'should accept a hash with both :attributes and :tags keys' do
        lambda {
          Element.new(:tag_name, {:attributes => "", :tags => ""})
        }.should_not raise_error
      end
    end

    describe '#text' do
      let(:element) { Element.new(:tag_name, {:attributes => "", :tags => ""}) }

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

          it 'should set the text value of the element to that parameter' do
            element.text "Example text"
            element.text.should == "Example text"
          end
        end
      end
    end

    context 'element with one tag' do
      let(:element) { Element.new(:tags, DTD::TAGS) }

      it 'should return an error when trying to set an invalid tag' do
        expect { element.bad "Example text" }.to raise_error
        expect { element.bad }.to raise_error
        expect { element.add_bad "Example text" }.to raise_error
      end

      describe '#tag' do
        context 'called for the first time without parameters' do
          it 'should return an Element instance with a proper DTD and no text' do
            element.tag.class.should == Element
            element.tag.dtd.should == DTD::BASIC_ELEMENT
            element.tag.text.should == ""
          end
        end

        context 'called a second time' do
          it 'should return the same object' do
            tag_tag = element.tag
            tag_tag.object_id.should == element.tag.object_id
          end
        end

        context 'called with a string' do
          it 'should set the new elements text with that value' do
            element.tag "Example text"
            element.tag.text.should == "Example text"
          end
        end

        context 'called with a block' do
          it 'should yield that block with the "tag" element as an argument' do
            lambda {
              element.tag { |tag| tag.text "Example text" }
            }.should_not raise_error
            element.tag.text.should == "Example text"
          end
        end
      end

      describe '#tag_list' do
        context 'when no "tag" tags have been added' do
          it 'should return an empty list' do
            element.tag_list.should == []
          end
        end

        context 'when one tag has been added with the #tag method' do
          it 'should return a list with one element' do
            element.tag "Example text"
            element.tag_list.length.should == 1
            element.tag_list[0].class.should == Element
          end
        end
      end

      describe '#add_tag' do
        context 'when no tags preset' do
          it 'should create that one tag' do
            element.add_tag "Example text"
            element.tag.text.should == "Example text"
            element.tag_list.length.should == 1
          end
        end

        context 'when called a second time' do
          before(:each) { element.add_tag "Example text 1" }
          it 'should add another tag of the same type' do
            element.add_tag "Example text 2"
            element.tag_list.length.should == 2
            element.tag_list[0].text.should == "Example text 1"
            element.tag_list[1].text.should == "Example text 2"
          end
        end

        context 'called with a block' do
          it 'should yield that block with the new "tag" element as an argument' do
            lambda {
              element.add_tag { |tag| tag.text "Example text" }
            }.should_not raise_error
            element.tag.text.should == "Example text"
          end
        end
      end

      describe '#available_tags' do
        let(:element) { Element.new(:tags, DTD::TAGS) }

        it 'should return the list of possible child tags' do
          element.available_tags == [:tag]
        end
      end
    end

    context 'with attributes, CHANNEL tag for example' do
      let(:element) { Element.new(:channel, DTD::CHANNEL) }

      describe '#available_attributes' do
        it 'should return the list of attributes valid for that element' do
          attr_list = element.available_attributes
          attr_list.should include(:xmlns)
          attr_list.should include(:version)
          attr_list.should include(:lang)
        end
      end

      describe '#xmlns_attr' do
        it 'should return an empty string if it was not yet set' do
          element.xmlns_attr.should == ""
        end

        it 'should return the preset value if the attribute was set' do
          element.xmlns_attr "Example value"
          element.xmlns_attr.should == "Example value"
        end

        it 'should allow redefining the value of the attribute' do
          element.xmlns_attr "Example value"
          element.xmlns_attr "Another example value"
          element.xmlns_attr.should == "Another example value"
        end
      end

      describe '#to_xml' do
        it 'should include the attribute value in xml' do
          element.xmlns_attr "Example value"
          element.to_xml.should include('<channel xmlns="Example value"></channel>')
        end

        it 'should include values for multiple attributes in xml' do
          element.xmlns_attr "xmlns value"
          element.version_attr "Version value"
          element.to_xml.should include('xmlns="xmlns value"')
          element.to_xml.should include('version="Version value"')
        end
      end
    end

    context 'with a child tag with attributes, CATEGORIES tag for example' do
      let(:element) { Element.new(:categories, DTD::CATEGORIES) }

      describe '#item' do
        it 'should accept setting of the attribute value in a hash argument' do
          element.item :type => "competition"
          element.item.type_attr.should == "competition"
        end

        it 'should accept setting both text and attributes at the same time' do
          element.item "Example text", :type => "competition"
          element.item.type_attr.should == "competition"
          element.item.text.should == "Example text"
        end
      end

      describe '#add_item' do
        it 'should accept setting both text and attributes in a hash argument at the same time' do
          element.add_item "Example text", :type => "competition"
          element.item.type_attr.should == "competition"
          element.item.text.should == "Example text"
        end
      end
    end

    describe '#to_xml' do
      let(:element) { Element.new(:channel, DTD::CHANNEL) }

      it 'should return a string' do
        element.to_xml.class.should == String
      end

      context 'when the element is completely empty' do
        it 'should return at least the starting and ending tags' do
          element.to_xml.should include("<channel></channel>")
        end
      end

      context 'when the element has text preset' do
        before(:each) { element.text "Example text" }
        it 'should return the starting and ending tags with the text between them' do
          element.to_xml.should include("<channel>Example text</channel>")
        end
      end

      context 'when the element has child elements' do
        before(:each) { element.title "An example channel" }
        it 'should return the starting and ending tags, and the same for the child tag' do
          element.to_xml.should include("<channel><title>An example channel</title></channel>")
        end
      end
    end

    context 'with attributes with restricted value, for example DATE_ITEM' do
      let(:element) { Element.new(:item, DTD::DATE_ITEM) }

      it 'should allow valid value for that attribute' do
        lambda {
          element.type_attr "standalone"
        }.should_not raise_error
      end

      it 'should raise error if an invalid value was used for an attribute' do
        expect { element.type_attr "bad_value" }.to raise_error
      end
    end

    describe '#valid?' do
      context 'called on an element with one mandatory tag with infinite number' do
        let(:element) { Element.new :tags, DTD::TAGS }

        it 'should return false if that mandatory tag was not defined' do
          element.should_not be_valid
        end

        it 'should return true if there is one mandatory tag defined' do
          element.tag "Example text"
          element.should be_valid
        end

        it 'should return true if there are more then one instances of that tag' do
          element.add_tag "Example text 1"
          element.add_tag "Example text 2"
          element.should be_valid
        end
      end

      context 'called on an element with mandatory tags and counter restricted' do
        let(:element) { Element.new :tags, DTD::RELATION_ITEM }

        it 'should return true if all tags presents and within limits' do
          element.name "Example name"
          element.uri "Example uri"
          element.id "Example id"
          element.should be_valid
        end
        it 'should return false if at least one tag has too many elements' do
          element.add_name "Example name 1"
          element.add_name "Example name 2"
          element.uri "Example uri"
          element.id "Example id"
          element.should_not be_valid
        end
      end

      context 'when child elements need to be tested too' do
        let(:element) do
          element = Element.new :feed, DTD::FEED
          element.title "A title"
          element.id "An ID"
          element.access "PUBLIC"
          element.description "desc"
          element.published Time.now.to_s
          element.uri "Sample uri"
          element.categories.add_item do |item|
            item.name "A name"
            item.id "An ID"
          end
          element.dates.add_item do |item|
            item.name "A name"
            item.start Time.now.to_s
          end
          element.places.add_item do |item|
            item.name "A name"
          end
          element
        end

        it 'should return true if a valid element was generated' do
          element.should be_valid
        end

        it 'should return false if a child of the element is not valid' do
          # Creating a places item without a name tag to make it invalid
          element.places.add_item
          element.should_not be_valid
        end
      end
    end

    describe 'tag valid values' do
      let(:element) { Element.new :feed, DTD::FEED }

      describe '#access' do
        it 'should allow PUBLIC and PRIVATE values' do
          lambda {
            element.access "PUBLIC"
            element.access "PRIVATE"
          }.should_not raise_error
        end

        it 'should not allow other values' do
          expect { element.access "bad" }.to raise_error
        end
      end
    end

    describe 'postprocessing' do
      describe 'Feed element' do
        let(:element) { Element.new(:feed, DTD::FEED) }

        describe '#title' do
          it 'should automatically set the feed id to a uuid(title)' do
            a_title = "A title"
            element.title a_title
            element.id.text.should == Helpers::uuid(a_title, 'EVENTID:')
          end
        end

        describe '#add_title' do
          it 'should automatically set the feed id to a uuid(title)' do
            a_title = "A title"
            element.add_title a_title
            element.id.text.should == Helpers::uuid(a_title, 'EVENTID:')
          end
        end

        describe '#uri' do
          it 'should automatically set the feed id to a uuid(uri)' do
            an_uri = "http://event/uri/"
            element.uri an_uri
            element.id.text.should == Helpers::uuid(an_uri, 'EVENTID:')
          end
        end

        describe '#add_uri' do
          it 'should automatically set the feed id to a uuid(uri)' do
            an_uri = "http://event/uri/"
            element.add_uri an_uri
            element.id.text.should == Helpers::uuid(an_uri, 'EVENTID:')
          end
        end

        describe '#id' do
          it 'should replace id with a regular event uuid when receiving regular text' do
            element.id "Some text"
            element.id.text.should == Helpers::uuid("Some text", 'EVENTID:')
          end
        end

        describe '#published' do
          it 'should accept Time objects and return a string in ISO8601 format' do
            current_time = Time.now
            element.published current_time
            element.published.text.should == current_time.iso8601
          end

          it 'should accept string in ISO8601 format and keep them the same' do
            current_time = Time.now.iso8601
            element.published current_time
            element.published.text.should == current_time
          end
        end
      end

      describe 'Description element' do
        let(:element) { Element.new :description, DTD::DESCRIPTION }
        it 'should strip unwanted tags from the description' do
          desc = "<p> About this feed...  </p> <script src=\"test.js\"></script>"
          element.text desc
          element.text.should == "<p> About this feed...  </p>"
        end
      end
    end
  end
end


require 'ess/helpers'
require 'time'

module ESS
  module Postprocessing
    class FeedTitle
      def process feed_tag, title_tag
        feed_tag.id(title_tag.text!) if feed_tag.id.text! == ""
      end
    end

    class FeedURI
      def process feed_tag, uri_tag
        feed_tag.id(uri_tag.text!) if feed_tag.id.text! == ""
      end
    end

    class FeedID
      def process feed_tag, id_tag
        unless id_tag.text!.start_with?('EVENTID:') || id_tag.text! == ""
          id_tag.text!(Helpers::uuid(id_tag.text!, 'EVENTID:'))
        end
      end
    end

    class ChannelTitle
      def process channel_tag, title_tag
        channel_tag.id(title_tag.text!) if channel_tag.id.text! == ""
      end
    end

    class ChannelID
      def process channel_tag, id_tag
        unless id_tag.text!.start_with?('ESSID:') || id_tag.text! == ""
          id_tag.text!(Helpers::uuid(id_tag.text!, 'ESSID:'))
        end
      end
    end

    class ChannelLink
      def process channel_tag, link_tag
        channel_tag.id(link_tag.text!) if channel_tag.id.text! == ""
      end
    end

    class ProcessTime
      def process text
        time = text
        time = DateTime.parse(time) if time.class != Time
        time.iso8601
      end
    end

    class StripSpecificHTMLTags
      def process text
        # skip any empty space between two tags
        text = text.gsub(/>\s+</, '><')
        text = text.gsub(/<noscript[^>]*?>.*?<\/noscript>/mi, '')
        text = text.gsub(/<iframe[^>]*?>.*?<\/iframe>/mi, '')
        text = text.gsub(/<script[^>]*?>.*?<\/script>/mi, '')
        test = text.gsub(/<style[^>]*?>.*?<\/style>/mi, '')
        test = text.gsub(/<![\s\S]*?--[ \t\n\r]*>/, '')
        return text
      end
    end
  end
end


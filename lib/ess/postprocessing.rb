require 'ess/helpers'
require 'time'

module ESS
  module Postprocessing
    class FeedTitle
      def process feed_tag, title_tag
        feed_tag.id(title_tag.text, 'EVENTID:')
      end
    end

    class FeedURI
      def process feed_tag, uri_tag
        feed_tag.id(uri_tag.text, 'EVENTID:')
      end
    end

    class FeedID
      def process feed_tag, id_tag
        unless id_tag.text.start_with?('EVENTID:')
          id_tag.text(Helpers::uuid(id_tag.text, 'EVENTID:'))
        end
      end
    end

    class ProcessTime
      def process feed_tag, published_tag
        time = published_tag.text
        if time.class != Time
          time = DateTime.parse time
        end
        published_tag.text time.iso8601
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


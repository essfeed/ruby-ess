module ESS
  class Maker
    def self.make version="0.9", lang="en", &block
      channel = Channel.new
      channel.xmlns_attr "http://essfeed.org/history/0.9"
      channel.version_attr version
      channel.lang_attr lang
      block.call(channel) if block
      return channel
    end
  end
end


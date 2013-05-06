module ESS
  class Maker
    DEFAULT_OPTIONS = {
      :version => "0.9",
      :lang => "en",
      :validate => true
    }

    def self.make options={}, &block
      options = DEFAULT_OPTIONS.merge options
      channel = Channel.new
      channel.xmlns_attr "http://essfeed.org/history/#{options[:version]}"
      channel.version_attr options[:version]
      channel.lang_attr options[:lang]
      block.call(channel) if block
      raise RuntimeError, "The resulting ESS channel is not valid" unless !options[:validate] || channel.valid?
      return channel
    end
  end
end


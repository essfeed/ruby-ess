module ESS
  class Maker
    DEFAULT_OPTIONS = {
      :version => "0.9",
      :lang => "en",
      :validate => true
    }

    def self.make options={}, &block
      options = DEFAULT_OPTIONS.merge options
      ess = ESS.new
      ess.xmlns_attr "http://essfeed.org/history/#{options[:version]}"
      ess.version_attr options[:version]
      ess.lang_attr options[:lang]
      block.call(ess) if block
      ess.validate if options[:validate]
      return ess
    end
  end
end


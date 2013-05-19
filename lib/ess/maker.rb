module ESS
  class Maker
    DEFAULT_OPTIONS = {
      :version => "0.9",
      :lang => "en",
      :validate => true,
      :push => false
    }

    def self.make options={}, &block
      options = DEFAULT_OPTIONS.merge options
      ess = ESS.new
      ess.xmlns_attr "http://essfeed.org/history/#{options[:version]}"
      ess.version_attr options[:version]
      ess.lang_attr options[:lang]
      block.call(ess) if block
      ess.channel.generator.text!("ess:ruby:generator:version:#{VERSION}") if ess.channel.generator.text! == ""
      ess.validate if options[:validate]
      ess.push_to_aggregators(options) if options[:push] || options[:aggregators]
      return ess
    end
  end
end


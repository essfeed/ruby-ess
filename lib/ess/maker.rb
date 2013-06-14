module ESS
  class Maker

    ##
    # Create a new ESS document. See README for examples on how it should
    # be used.
    #
    # === Yields
    #
    # [ESS::ESS] object representing the "ess" root tag of an ESS document
    #
    # === Options
    #
    # Currently, the following options are defined:
    #
    # ==== :push
    #
    # Whether to push the resulting document to aggregators before returning
    # from the method. Default is false.
    #
    # ==== :validate
    #
    # Validate resulting document before returning from the method. Default
    # is true.
    #
    # ==== :version
    #
    # Set a different value for the "version" attribute of the "ess" tag.
    # Default is "0.9".
    #
    # ==== :lang
    #
    # Set a value for the "lang" attribute of the "ess" tag. Default is "en".
    #
    def self.make options={}, &block
      options = DEFAULT_OPTIONS.merge options
      ess = ESS.new
      ess.xmlns_attr "http://essfeed.org/history/#{options[:version]}"
      ess.version_attr options[:version]
      ess.lang_attr options[:lang]
      block.call(ess) if block
      ess.channel.generator.text!("ess:ruby:generator:version:#{options[:version]}") if ess.channel.generator.text! == ""
      ess.validate if options[:validate]
      ess.push_to_aggregators(options) if options[:push] || options[:aggregators]
      return ess
    end

    private

      DEFAULT_OPTIONS = {
        :version => "0.9",
        :lang => "en",
        :validate => true,
        :push => false
      }
  end
end


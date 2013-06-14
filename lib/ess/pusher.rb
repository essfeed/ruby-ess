require 'rubygems'
require 'json'
require 'net/http'
require 'uri'

module ESS
  module Pusher
    ##
    # Sets the default aggregator services. Accepts a list of links in strings.
    #
    def self.aggregators= aggs
      raise ArgumentError, "this method requires a list of links" if aggs.class != Array
      @@aggregators = aggs
    end

    ##
    # Returns the aggregator services currently set as default.
    #
    def self.aggregators
      @@aggregators ||= ["http://api.hypecal.com/v1/ess/aggregator.json"]
    end

    ##
    # Pushes the feed to aggregators.
    #
    # === Options
    #
    # ==== :data
    #
    # A string, with an XML document representing the feed that needs to be
    # pushed.
    #
    # ==== :feed
    #
    # This is an alternative to the :data option. This method accepts the feed
    # link instead of the whole document. The aggregator service will pull the
    # feed using this link.
    #
    # ==== :request
    #
    # This should be the request object that generated this feed. It can be
    # useful for the aggregator service to receive some of th information
    # from this object for crawling purposes.
    #
    # ==== :aggregators
    #
    # Intead of using the default aggregator services, this options can be used
    # to specify what aggregators should the document be pushed to.
    #
    # ==== :ignore_errors
    #
    # The method will ignore any response from the aggregator services if this
    # option is true. Default is false.
    #
    def self.push_to_aggregators options={}
      options = { :aggregators => Pusher::aggregators,
                  :feed => nil,
                  :data => nil,
                  :request => nil,
                  :ignore_errors => false }.merge options
      options[:aggregators].each do |aggregator|
        url = URI.parse(aggregator)
        request = Net::HTTP::Post.new(url.path)

        form_data = { "output" => "json",
                      "LIBRARY_VERSION" => VERSION }
        form_data["SERVER_ADMIN"] = ENV["SERVER_ADMIN"] if ENV["SERVER_ADMIN"]
        if ENV["SERVER_PROTOCOL"]
          if ENV["SERVER_PROTOCOL"].include? "HTTPS"
            form_data["SERVER_PROTOCOL"] = "https://"
          else
            form_data["SERVER_PROTOCOL"] = "http://"
          end
        end
        form_data["HTTP_HOST"] = ENV["HTTP_HOST"] if ENV["HTTP_HOST"]
        if options[:request]
          form_data["REMOTE_ADDR"] = options[:request].remote_ip
          form_data["REQUEST_URI"] = options[:request].fullpath
        end
        form_data["GEOIP_LATITUDE"] = ENV["GEOIP_LATITUDE"] if ENV["GEOIP_LATITUDE"]
        form_data["GEOIP_LONGITUDE"] = ENV["GEOIP_LONGITUDE"] if ENV["GEOIP_LONGITUDE"]

        if options[:feed].nil?
          form_data["feed_file"] = options[:data]
        else
          form_data["feed"] = options[:feed]
        end
        request.form_data = form_data
        response = Net::HTTP.start(url.host, url.port) { |http| http.request(request) }
        response = JSON.parse response.body
        unless options[:ignore_errors]
          errors = response["result"]["error"]
          unless errors.nil?
            raise RuntimeError, "errors while submitting feed: #{errors}"
          end
        end
      end
    end
  end
end


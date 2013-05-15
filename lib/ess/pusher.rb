require 'net/http'
require 'uri'

module ESS
  module Pusher
    def self.aggregators= aggs
      raise ArgumentError, "this method requires a list of links" if aggs.class != Array
      @@aggregators = aggs
    end

    def self.aggregators
      @@aggregators ||= ["http://api.hypecal.com/v1/ess/aggregator.json"]
    end

    def self.push_to_aggregators options={}
      options = { :aggregators => Pusher::aggregators,
                  :feed => nil,
                  :data => nil,
                  :request => nil }.merge options
      responses = options[:aggregators].map do |aggregator|
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
          request = options[:request]
          form_data["REMOTE_ADDR"] = request.remote_ip
          form_data["REQUEST_URI"] = request.fullpath
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
      end
      return responses
    end

    def push_to_aggregators options={}
      options = options.clone
      if @name != :ess
        raise RuntimeError, "only ESS root element can be pushed to aggregators"
      end
      options[:data] = self.to_xml!
      Pusher::push_to_aggregators options
    end
  end
end


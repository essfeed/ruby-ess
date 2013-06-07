require 'builder'
require 'ess/helpers'
require 'ess/pusher'

module ESS
  class Element
    include ESS::Helpers

    attr_reader :dtd

    def initialize name, dtd
      @name, @dtd = name, dtd
    end

    def name!
      @name
    end

    def text! text=nil
      return @text ||= "" if text.nil?
      @text = do_text_postprocessing_of text
    end

    def inspect
      "#<#{self.class}:#{object_id} text=\"#{@text}\">"
    end

    def validate
      run_tag_validators
      check_attributes
      check_child_tags
      return nil # if no errors found, i.e. no exceptions have been raised
    end

    def valid?
      begin
        validate
      rescue
        return false
      end
      return true
    end

    def to_xml! xml=nil
      convert_to_string = true if xml.nil?
      xml = Builder::XmlMarkup.new if xml.nil?
      if @name == :ess
        xml.instruct! :xml, :encoding => "UTF-8"
        xml.declare! :DOCTYPE, :ess, :PUBLIC, "-//ESS//DTD", "http://essfeed.org/history/0.9/index.dtd"
      end
      xml.tag! @name, attributes do |p|
        if !@text.nil?
          if @dtd[:cdata]
            p.cdata! @text
          else
            p.text! @text
          end
        end
        child_tags.values.each { |tag_list| tag_list.each { |tag| tag.to_xml!(p) } }
      end
      xml.target! if convert_to_string
    end

    def push_to_aggregators options={}
      raise RuntimeError, "only ESS root element can be pushed to aggregators" if @name != :ess
      options[:data] = self.to_xml!
      Pusher::push_to_aggregators options
    end

    def to_s
      to_xml!
    end

    def disable_postprocessing
      @@postprocessing_disabled = true
    end

    def enable_postprocessing
      @@postprocessing_disabled = false
    end

    def postprocessing_disabled?
      @@postprocessing_disabled ||= false
    end

    def method_missing m, *args, &block
      if method_name_is_tag_name? m
        return assign_tag(m, args, &block)
      elsif method_name_is_tag_adder_method? m 
        return extend_tag_list(m, args, &block)
      elsif method_name_is_tag_list_method? m
        return child_tags[m[0..-6].to_sym] ||= []
      elsif method_name_is_attr_accessor_method? m
        return assign_attribute(m[0..-6].to_sym, args, &block)
      end
      super(m, *args, &block)
    end

    private

      def method_name_is_tag_name? method_name
        available_tags.include? method_name
      end

      def method_name_is_tag_adder_method? method_name
        method_name.to_s.start_with?("add_") && available_tags.include?(method_name[4..-1].to_sym)
      end

      def method_name_is_tag_list_method? method_name
        method_name.to_s.end_with?("_list") && available_tags.include?(method_name[0..-6].to_sym)
      end

      def method_name_is_attr_accessor_method? method_name
        method_name.to_s.end_with?("_attr") && available_attributes.include?(method_name[0..-6].to_sym)
      end

      def assign_attribute attr_name, args, &block
        if args.any?
          attr_value = args[0].to_s
          check_attribute_value attr_name, attr_value
          attributes[attr_name] = attr_value
        else
          attributes[attr_name] || ""
        end
      end

      def check_attribute_value attr_name, attr_value
        attr_desc = @dtd[:attributes][attr_name]
        if attr_value && attr_desc.has_key?(:valid_values)
          valid_values = attr_desc[:valid_values]
          if !valid_values.include? attr_value
            unless attr_value.split(",").map { |value| valid_values.include? value }.all?
              raise DTD::InvalidValueError, "Invalid attribute value \"#{attr_value}\" for \"#{attr_name}\" attribute"
            end
          end
        end
      end

      def assign_tag m, args, &block
        arg_hash = {}
        args.each { |arg| arg_hash = arg if arg.class == Hash }
        tag_list = child_tags[m] ||= [Element.new(m, @dtd[:tags][m][:dtd])]
        if args.length > 0 && args[0].class != Hash
          if @dtd[:tags][m].include? :valid_values
            unless @dtd[:tags][m][:valid_values].include?(args[0])
              raise DTD::InvalidValueError, "\"#{args[0]}\" is not a valid value for the #{m} tag"
            end
          end
          tag_list[0].text!(args[0])
        end
        arg_hash.each_pair { |key, value| tag_list[0].send([key, "_attr"].join("").to_sym, value) }
        block.call tag_list[0] if block
        run_post_processing tag_list[0]
        return tag_list[0]
      end

      def extend_tag_list m, args, &block
        arg_hash = {}
        args.each { |arg| arg_hash = arg if arg.class == Hash }
        tag_name = m[4..-1].to_sym
        new_tag = Element.new(tag_name, @dtd[:tags][tag_name][:dtd])
        new_tag.text!(args[0]) if args.any? && args[0].class == String
        arg_hash.each_pair { |key, value| new_tag.send([key, "_attr"].join("").to_sym, value) }
        block.call new_tag if block
        (child_tags[tag_name] ||= []).push new_tag
        run_post_processing new_tag
        return new_tag
      end

      def run_post_processing tag
        unless postprocessing_disabled?
          if @dtd[:tags][tag.name!].keys.include? :postprocessing
            @dtd[:tags][tag.name!][:postprocessing].each { |processor| processor.process(self, tag) }
          end
        end
      end

      def child_tags
        @child_tags ||= {}
      end

      def attributes
        @attributes ||= {}
      end

      def do_text_postprocessing_of text
        unless postprocessing_disabled?
          text = text.to_s if text.class != String
          if @dtd.include? :postprocessing_text
            @dtd[:postprocessing_text].each do |processor|
              text = processor.process text
            end
          end
        end
        text
      end

      def available_tags
        return [] if @dtd[:tags].nil?
        @dtd[:tags].keys
      end

      def available_attributes
        return [] if @dtd[:attributes].nil?
        @dtd[:attributes].keys
      end


      # Validation helpers:

      def run_tag_validators
        if @dtd.include? :validation
          @dtd[:validation].each { |validator| validator.validate self }
        end
      end

      def check_attributes
        if @dtd.include? :attributes
          @dtd[:attributes].each_pair do |attr_name, attr_desc|
            check_mandatory_attribute(attr_name) if attr_desc[:mandatory]
            check_attribute_cardinality(attr_name, attr_desc[:max_occurs])
          end
        end
      end

      def check_mandatory_attribute attr_name
        attr_value = attributes[attr_name]
        if attr_value.nil? ||  attr_value == ""
          raise Validation::ValidationError, "missing mandatory attribute #{attr_name} from <#{@name}> element"
        end
      end

      def check_attribute_cardinality attr_name, max_occurs
        unless max_occurs.nil?
          unless max_occurs == :inf
            attr_value = attributes[attr_name]
            unless attr_value.nil? || attr_value.split(",").length <= max_occurs.to_i
              raise Validation::ValidationError, "too many values for attribute #{attr_name}: #{attr_value}"
            end
          end
        end
      end

      def check_child_tags
        if @dtd.include? :tags
          @dtd[:tags].each_pair do |tag_name, tag_desc|
            check_mandatory_child_tag(tag_name) if tag_desc[:mandatory]
            check_child_tag_cardinality(tag_name, tag_desc[:max_occurs])
          end
          run_validate_for_each_child_tag
        end
      end

      def check_mandatory_child_tag tag_name
        unless child_tags.include?(tag_name) && child_tags[tag_name].length > 0
          raise Validation::ValidationError, "<#{tag_name}> is a mandatory tag in <#{@name}>"
        end
      end

      def check_child_tag_cardinality tag_name, max_occurs
        if max_occurs != :inf
          if child_tags.include?(tag_name)
            if child_tags[tag_name].length > 0
              if child_tags[tag_name].length > max_occurs.to_i
                raise Validation::ValidationError, "< #{tag_name} > can occur maximally #{max_occurs.to_i} times in < #{@name} >"
              end
            end
          end
        end
      end

      def run_validate_for_each_child_tag
        child_tags.values.each do |a_tags_list|
          a_tags_list.each do |one_tag|
            one_tag.validate
          end
        end
      end

  end
end


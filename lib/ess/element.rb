require 'builder'
require 'ess/helpers'

module ESS
  class Element
    include ESS::Helpers

    attr_reader :dtd

    def initialize name, dtd
      raise "Bad DTD: no attributes description" if !dtd.include? :attributes
      raise "Bad DTD: no tags description" if !dtd.include? :tags
      @name = name
      @dtd = dtd
      @child_tags = {}
      @attributes = {}
    end

    def name!
      @name
    end

    def text text=nil
      if text.nil?
        return @text ||= ""
      else
        if @dtd.include? :postprocessing_text
          puts "Tu sam"
          @dtd[:postprocessing_text].each do |processor|
            text = processor.process text
          end
        end
        @text = text
      end
    end

    def available_tags
      return [] if @dtd[:tags].nil?
      @dtd[:tags].keys
    end

    def available_attributes
      @dtd[:attributes].keys
    end

    def inspect
      "#<#{self.class}:#{object_id} text=\"#{@text}\">"
    end

    def valid?
      if !@dtd[:tags].nil?
        @dtd[:tags].each_pair do |tag_name, tag_desc|
          if tag_desc[:mandatory] && 
                (!@child_tags.include?(tag_name) || @child_tags[tag_name].length == 0)
            return false
          end
          if tag_desc[:max_occurs] != :inf &&
                (@child_tags.include?(tag_name) && @child_tags[tag_name].length != 0)
            if tag_desc[:max_occurs].to_i < @child_tags[tag_name].length
              return false
            end
          end
          child_tags_valid = @child_tags.values.map do |a_tags_list|
            tags_in_list_valid = a_tags_list.map do |one_tag|
              one_tag.valid?
            end
            tags_in_list_valid.all?
          end
          return false if !child_tags_valid.all?
        end
      end
      return true
    end

    def to_xml xml=nil
      convert_to_string = true if xml.nil?
      if xml.nil?
        xml = Builder::XmlMarkup.new
        xml.instruct! :xml, :encoding => "UTF-8"
        xml.declare! :DOCTYPE, :ess, :PUBLIC, "-//ESS//DTD", "http://essfeed.org/history/0.9/index.dtd"
      end
      xml.tag! @name, @attributes do |p|
        p.text! @text if !@text.nil?
        @child_tags.values.each { |tag_list| tag_list.each { |tag| tag.to_xml(p) } }
      end
      xml.target! if convert_to_string
    end

    def method_missing m, *args, &block
      if available_tags.include? m
        return assign_tag(m, args, &block)
      elsif m.to_s.start_with? "add_"
        tag_name = m[4..-1].to_sym
        return extend_tag_list(m, args, &block) if available_tags.include?(tag_name)
      elsif m.to_s.end_with? "_list"
        tag_name = m[0..-6].to_sym
        return (@child_tags[tag_name] ||= []) if available_tags.include?(tag_name)
      elsif m.to_s.end_with? "_attr"
        attr_name = m[0..-6].to_sym
        return set_attribute(attr_name, args, &block) if available_attributes.include? attr_name
      end
      super(m, *args, &block)
    end

    private

      def set_attribute attr_name, args, &block
        attr_value = nil
        attr_value = args[0] if args.any? && args[0].class == String
        if !attr_value.nil? && @dtd[:attributes][attr_name].has_key?(:valid_values)
          if !@dtd[:attributes][attr_name][:valid_values].include? attr_value
            raise DTD::InvalidValueError, "Invalid attribute value \"#{attr_value}\" for :#{attr_name} attribute"
          end
        end
        @attributes[attr_name] = attr_value if !attr_value.nil?
        @attributes[attr_name] ||= ""
      end

      def assign_tag m, args, &block
        arg_hash = {}
        args.each { |arg| arg_hash = arg if arg.class == Hash }
        tag_list = @child_tags[m] ||= [Element.new(m, @dtd[:tags][m][:dtd])]
        if args.length > 0 && args[0].class != Hash
          if @dtd[:tags][m].include? :valid_values
            unless @dtd[:tags][m][:valid_values].include?(args[0])
              raise InvalidValueError, "\"#{args[0]}\" is not a valid value for the #{m} tag"
            end
          end
          tag_list[0].text(args[0])
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
        new_tag.text(args[0]) if args.any? && args[0].class == String
        arg_hash.each_pair { |key, value| new_tag.send([key, "_attr"].join("").to_sym, value) }
        block.call new_tag if block
        (@child_tags[tag_name] ||= []).push new_tag
        run_post_processing new_tag
        return new_tag
      end

      def run_post_processing tag
        if @dtd[:tags][tag.name!].keys.include? :postprocessing
          @dtd[:tags][tag.name!][:postprocessing].each { |processor| processor.process(self, tag) }
        end
      end
  end
end


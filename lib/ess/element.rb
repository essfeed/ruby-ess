require 'builder'

module ESS
  class Element
    attr_reader :dtd

    def initialize name, dtd
      raise "Bad DTD: no attributes description" if !dtd.include? :attributes
      raise "Bad DTD: no tags description" if !dtd.include? :tags
      @name = name
      @dtd = dtd
      @child_tags = {}
      @attributes = {}
    end

    def text text=nil
      if text.nil?
        return @text ||= ""
      elsif text.class == String
        @text = text
      else
        raise TypeError.new "Only strings can be used as a value for the element text"
      end
    end

    def available_tags
      @dtd[:tags].keys
    end

    def available_attributes
      @dtd[:attributes].keys
    end

    def inspect
      "#<#{self.class}:#{object_id} text=\"#{@text}\">"
    end

    def to_xml xml=nil
      convert_to_string = true if xml.nil?
      if xml.nil?
        xml = Builder::XmlMarkup.new
        xml.instruct! :xml, :encoding => "UTF-8"
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
        @attributes[attr_name] = args[0] if args.any? && args[0].class == String
        @attributes[attr_name] ||= ""
      end

      def assign_tag m, args, &block
        arg_hash = {}
        args.each { |arg| arg_hash = arg if arg.class == Hash }
        tag_list = @child_tags[m] ||= [Element.new(m, @dtd[:tags][m][:dtd])]
        tag_list[0].text(args[0]) if args.any? && args[0].class == String
        arg_hash.each_pair { |key, value| tag_list[0].send([key, "_attr"].join("").to_sym, value) }
        block.call tag_list[0] if block
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
        return new_tag
      end
  end
end


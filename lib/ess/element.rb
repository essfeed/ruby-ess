module ESS
  class Element

    def initialize dtd
      raise "Bad DTD: no attributes description" if !dtd.include? :attributes
      raise "Bad DTD: no tags description" if !dtd.include? :tags
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

    private

      def set_child child_name, new_value
        if new_value.class == String
          @children[child_name] = Element.new(new_value)
        elsif new_value.class == Element
          @children[child_name] = new_value
        else
          raise TypeError.new "only strings and #{Element} objects can be used to set the #{child_name}"
        end
      end
  end
end


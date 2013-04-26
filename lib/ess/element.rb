module ESS
  class Element
    attr_reader :text

    def initialize text=""
      @text = text
      @children = {}
    end

    def text= new_text
      if new_text.class == String
        @text = new_text
      else
        raise TypeError.new "only strings can be used as a value for the element text"
      end
    end

    def valid?
    end

    private

      def self.add_child_elements *child_names
        child_names.each do |name|
          define_element_reader_method_for name
          define_element_writer_method_for name
        end
      end

      def self.define_element_reader_method_for element_name
        define_method(element_name) do
          get_child(element_name)
        end
      end

      def self.define_element_writer_method_for element_name
        define_method("#{element_name}=".to_sym) do |value|
          set_child(element_name, value)
        end
      end

      def get_child child_name
        return @children[child_name] if @children.include? child_name
      end

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


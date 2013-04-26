
module ESS
  class Channel

    def initialize
      @children = {}
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

    [:title, :link, :id, :published, :updated, :generator, :rights, :feed].each do |element_name|
      define_element_reader_method_for element_name
      define_element_writer_method_for element_name
    end

    def valid?
    end

    private

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


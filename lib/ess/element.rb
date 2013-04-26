module ESS
  class Element
    attr_reader :text

    def initialize text=""
      @text = text
    end

    def text= new_text
      if new_text.class == String
        @text = new_text
      else
        raise TypeError.new "only strings can be used to set the element text"
      end
    end
  end
end


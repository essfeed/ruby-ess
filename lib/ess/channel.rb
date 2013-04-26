
module ESS
  class Channel
    attr_reader :title

    def title= new_title
      if new_title.class == String
        @title = Element.new(new_title)
      elsif new_title.class == Element
        @title = new_title
      else
        raise TypeError.new "only strings and #{Element} objects can be used to set the title"
      end
    end

    def valid?
    end
  end
end


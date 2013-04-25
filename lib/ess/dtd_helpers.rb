module ESS
  module DTD
    class ItemDesc
      def initialize available, mandatory
        @available = available
        @mandatory = mandatory
      end

      def available?
        @available
      end

      def mandatory?
        @mandatory
      end
    end


    class GroupDesc
      def initialize desc
        @desc = desc.inject({}) do |h, (key, value)|
          h[key] = ItemDesc.new(true, value == :mandatory); h
        end
      end

      def method_missing m, *args, &block
        if @desc.has_key? m
          return @desc[m]
        else
          return ItemDesc.new(false, false)
        end
      end
    end

  end
end


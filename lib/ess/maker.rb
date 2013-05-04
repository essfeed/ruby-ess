module ESS
  class Maker
    def self.make version="0.9"
      yield Channel.new
    end
  end
end


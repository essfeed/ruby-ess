module ESS
  class Channel < Element
    def initialize
      super :channel, ESS::DTD::CHANNEL
    end
  end
end


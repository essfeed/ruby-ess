require 'ess/element'

module ESS
  class Channel < Element
    add_child_elements *DTD::CHANNEL.available_elements
  end
end


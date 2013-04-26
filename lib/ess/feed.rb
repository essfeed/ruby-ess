require 'ess/element'

module ESS
  class Feed < Element
    add_child_elements *DTD::FEED.available_elements
  end
end


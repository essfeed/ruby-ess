require "ess"
require "rexml/document"

module ESS
  class Parser
    def self.parse data
      doc = REXML::Document.new data
      ess = doc.root
      if ess.nil?
        raise ArgumentError, "the first argument has to contain a valid xml document"
      end
      new_ess = ESS.new
      new_ess.disable_postprocessing
      parse_element(ess, new_ess)
      new_ess.enable_postprocessing
      new_ess
    end

    def self.parse_element element, new_element=nil
      element.attributes.each_pair do |attr, value|
        new_element.send(attr + "_attr", value)
      end
      element.elements.each do |element|
        new_element.send("add_" + element.name, element.text) do |new_element|
          parse_element element, new_element
        end
      end
    end
  end
end


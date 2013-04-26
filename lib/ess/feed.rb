require 'ess/element'

module ESS
  class Feed < Element

    [:title, :id, :access, :description, :published, :uri, :updated, :tags].each do |element_name|
      define_element_reader_method_for element_name
      define_element_writer_method_for element_name
    end
  end
end


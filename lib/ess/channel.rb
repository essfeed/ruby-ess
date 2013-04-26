require 'ess/element'

module ESS
  class Channel < Element

    [:title, :link, :id, :published, :updated, :generator, :rights, :feed].each do |element_name|
      define_element_reader_method_for element_name
      define_element_writer_method_for element_name
    end
  end
end


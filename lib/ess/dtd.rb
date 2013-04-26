require "ess/dtd_helpers"

module ESS
  module DTD

    ESS_ATTRIBUTES = GroupDesc.new({
            :xmlns   => :mandatory,
            :version => :mandatory,
            :lang    => :mandatory })

    CHANNEL = GroupDesc.new({
            :title     => :mandatory,
            :link      => :mandatory,
            :id        => :mandatory,
            :published => :mandatory,
            :updated   => :optional,
            :generator => :optional,
            :rights    => :optional,
            :feed      => :mandatory })
    FEED = GroupDesc.new({
            :title       => :mandatory,
            :id          => :mandatory,
            :access      => :mandatory,
            :description => :mandatory,
            :published   => :mandatory,
            :uri         => :optional,
            :updated     => :optional,
            :tags        => :optional })
  end
end

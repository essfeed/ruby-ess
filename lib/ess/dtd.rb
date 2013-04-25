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
  end
end

require 'securerandom'
require 'digest/md5'

module ESS
  module Helpers
    ##
    # Generates an UUID with the prefix specified, using the kay passed to it.
    #
    def self.uuid key=nil, prefix='ESSID:'
      new_id = nil
      if key.nil?
        new_id = SecureRandom.uuid
      else
        chars = Digest::MD5.hexdigest(key)
        new_id = chars[0..8] + '-' +
                 chars[8..12] + '-' +
                 chars[12..16] + '-' +
                 chars[16..20] + '-' +
                 chars[20..32]
      end
      return prefix + new_id
    end
  end
end


module ESS
  module DTD

    BASIC_ELEMENT = { :attributes => nil, :children => nil }

    TAGS = {
      :attributes => nil,
      :children => { :tag => { :dtd => BASIC_ELEMENT,
                               :mandatory => false,
                               :maxOccurs => :inf }
      }
    }

    CATEGORY_ITEM = {
      :attributes => { :type => { :mandatory => false,
                                  :maxOccurs => 1 } },
      :children => { :name => { :dtd => BASIC_ELEMENT,
                                :mandatory => true,
                                :maxOccurs => 1 },
                     :id   => { :dtd => BASIC_ELEMENT,
                                :mandatory => true,
                                :maxOccurs => 1 }
      }
    }

    CATEGORIES = {
      :attributes => nil,
      :children => { :item => { :dtd => CATEGORY_ITEM,
                                :mandatory => true,
                                :maxOccurs => :inf }
      }
    }

    DATE_ITEM = {
      :attributes => { :type => { :mandatory => false,
                                  :maxOccurs => 1 },
                       :unit => { :mandatory => false,
                                  :maxoccurs => 1 },
                       :selected_day => { :mandatory => false,
                                          :maxOccurs => 1 },
                       :selected_week => { :mandatory => false,
                                           :maxOccurs => 1 } },
      :children => { :name => { :dtd => BASIC_ELEMENT,
                                :mandatory => true,
                                :maxOccurs => 1 },
                     :start => { :dtd => BASIC_ELEMENT,
                                 :mandatory => true,
                                 :maxOccurs => 1 },
                     :duration => { :dtd => BASIC_ELEMENT,
                                    :mandatory => false,
                                    :maxOccurs => 1 }
      }
    }

    DATES = {
      :attributes => nil,
      :children => { :item => { :dtd => DATE_ITEM,
                                :mandatory => true,
                                :maxOccurs => :inf }
      }
    }

    PLACE_ITEM = {
      :attributes => { :type => { :mandatory => false,
                                  :maxOccurs => 1 },
                       :priority => { :mandatory => false,
                                      :maxOccurs => 1 } },
      :children => { :name => { :dtd => BASIC_ELEMENT,
                                :mandatory => true,
                                :maxOccurs => 1 },
                     :country_code => { :dtd => BASIC_ELEMENT,
                                        :mandatory => false,
                                        :maxOccurs => 1 },
                     :country => { :dtd => BASIC_ELEMENT,
                                   :mandatory => false,
                                   :maxOccurs => 1 },
                     :latitude => { :dtd => BASIC_ELEMENT,
                                    :mandatory => false,
                                    :maxOccurs => 1 },
                     :longitude => { :dtd => BASIC_ELEMENT,
                                     :mandatory => false,
                                     :maxOccurs => 1 },
                     :address => { :dtd => BASIC_ELEMENT,
                                   :mandatory => false,
                                   :maxOccurs => 1 },
                     :city => { :dtd => BASIC_ELEMENT,
                                :mandatory => false,
                                :maxOccurs => 1 },
                     :zip => { :dtd => BASIC_ELEMENT,
                               :mandatory => false,
                               :maxOccurs => 1 },
                     :state => { :dtd => BASIC_ELEMENT,
                                 :mandatory => false,
                                 :maxOccurs => 1 },
                     :state_code => { :dtd => BASIC_ELEMENT,
                                      :mandatory => false,
                                      :maxOccurs => 1 },
                     :medium_name => { :dtd => BASIC_ELEMENT,
                                       :mandatory => false,
                                       :maxOccurs => 1 },
                     :medium_type => { :dtd => BASIC_ELEMENT,
                                       :mandatory => false,
                                       :maxOccurs => 1 },
                     :kml => { :dtd => BASIC_ELEMENT,
                               :mandatory => false,
                               :maxOccurs => 1 }
      }
    }

    PLACES = {
      :attributes => nil,
      :children => { :item => { :dtd => PLACE_ITEM,
                                :mandatory => true,
                                :maxOccurs => :inf }
      }
    }

    PRICE_ITEM = {
      :attributes => { :type => { :mandatory => false,
                                  :maxOccurs => 1 },
                       :mode => { :mandatory => false,
                                  :maxOccurs => 1 },
                       :unit => { :mandatory => false,
                                  :maxOccurs => 1 },
                       :selected_day => { :mandatory => false,
                                          :maxOccurs => 1 },
                       :selected_week => { :mandatory => false,
                                           :maxOccurs => 1 },
                       :priority => { :mandatory => false,
                                      :maxOccurs => 1 } },
      :children => { :name => { :dtd => BASIC_ELEMENT,
                                :mandatory => true,
                                :maxOccurs => 1 },
                     :value => { :dtd => BASIC_ELEMENT,
                                 :mandatory => true,
                                 :maxOccurs => 1 },
                     :currency => { :dtd => BASIC_ELEMENT,
                                    :mandatory => false,
                                    :maxOccurs => 1 },
                     :start => { :dtd => BASIC_ELEMENT,
                                 :mandatory => false,
                                 :maxOccurs => 1 },
                     :duration => { :dtd => BASIC_ELEMENT,
                                    :mandatory => false,
                                    :maxOccurs => 1 },
                     :uri => { :dtd => BASIC_ELEMENT,
                               :mandatory => false,
                               :maxOccurs => 1 }
      }
    }

    PRICES = {
      :attributes => nil,
      :children => { :item => { :dtd => PRICE_ITEM,
                                :mandatory => true,
                                :maxOccurs => :inf }
      }
    }

    MEDIA_ITEM = {
      :attributes => { :type => { :mandatory => false,
                                  :maxOccurs => 1 },
                       :priority => { :mandatory => false,
                                      :maxOccurs => 1 } },
      :children => { :name => { :dtd => BASIC_ELEMENT,
                                :mandatory => true,
                                :maxOccurs => 1 },
                     :uri => { :dtd => BASIC_ELEMENT,
                               :mandatory => true,
                               :maxOccurs => 1 }
      }
    }

    MEDIA = {
      :attributes => nil,
      :children => { :item => { :dtd => MEDIA_ITEM,
                                :mandatory => true,
                                :maxOccurs => :inf }
      }
    }

    PEOPLE_ITEM = {
      :attributes => { :type => { :mandatory => false,
                                  :maxOccurs => 1 } },
      :children => { :name => { :dtd => BASIC_ELEMENT,
                                :mandatory => true,
                                :maxOccurs => 1 },
                     :id => { :dtd => BASIC_ELEMENT,
                              :mandatory => false,
                              :maxOccurs => 1 },
                     :firstname => { :dtd => BASIC_ELEMENT,
                                     :mandatory => false,
                                     :maxOccurs => 1 },
                     :lastname => { :dtd => BASIC_ELEMENT,
                                    :mandatory => false,
                                    :maxOccurs => 1 },
                     :organization => { :dtd => BASIC_ELEMENT,
                                        :mandatory => false,
                                        :maxOccurs => 1 },
                     :logo => { :dtd => BASIC_ELEMENT,
                                :mandatory => false,
                                :maxOccurs => 1 },
                     :icon => { :dtd => BASIC_ELEMENT,
                                :mandatory => false,
                                :maxOccurs => 1 },
                     :uri => { :dtd => BASIC_ELEMENT,
                               :mandatory => false,
                               :maxOccurs => 1 },
                     :address => { :dtd => BASIC_ELEMENT,
                                   :mandatory => false,
                                   :maxOccurs => 1 },
                     :city => { :dtd => BASIC_ELEMENT,
                                :mandatory => false,
                                :maxOccurs => 1 },
                     :zip => { :dtd => BASIC_ELEMENT,
                               :mandatory => false,
                               :maxOccurs => 1 },
                     :state => { :dtd => BASIC_ELEMENT,
                                 :mandatory => false,
                                 :maxOccurs => 1 },
                     :state_code => { :dtd => BASIC_ELEMENT,
                                      :mandatory => false,
                                      :maxOccurs => 1 },
                     :country => { :dtd => BASIC_ELEMENT,
                                   :mandatory => false,
                                   :maxOccurs => 1 },
                     :country_code => { :dtd => BASIC_ELEMENT,
                                        :mandatory => false,
                                        :maxOccurs => 1 },
                     :email => { :dtd => BASIC_ELEMENT,
                                 :mandatory => false,
                                 :maxOccurs => 1 },
                     :phone => { :dtd => BASIC_ELEMENT,
                                 :mandatory => false,
                                 :maxOccurs => 1 },
                     :minpeople => { :dtd => BASIC_ELEMENT,
                                     :mandatory => false,
                                     :maxOccurs => 1 },
                     :maxpeople => { :dtd => BASIC_ELEMENT,
                                     :mandatory => false,
                                     :maxOccurs => 1 },
                     :minage => { :dtd => BASIC_ELEMENT,
                                  :mandatory => false,
                                  :maxOccurs => 1 },
                     :restriction => { :dtd => BASIC_ELEMENT,
                                       :mandatory => false,
                                       :maxOccurs => 1 }
      }
    }

    PEOPLE = {
      :attributes => nil,
      :children => { :item => { :dtd => PEOPLE_ITEM,
                                :mandatory => true,
                                :maxOccurs => :inf }
      }
    }

    RELATION_ITEM = {
      :attributes => { :type => { :mandatory => false,
                                  :maxOccurs => 1 } },
      :children => { :name => { :dtd => BASIC_ELEMENT,
                                :mandatory => true,
                                :maxOccurs => 1 },
                     :uri => { :dtd => BASIC_ELEMENT,
                               :mandatory => true,
                               :maxOccurs => 1 },
                     :id => { :dtd => BASIC_ELEMENT,
                              :mandatory => true,
                              :maxOccurs => 1 }
      }
    }

    RELATIONS = {
      :attributes => nil,
      :children => { :item => { :dtd => RELATION_ITEM,
                                :mandatory => true,
                                :maxOccurs => :inf }
      }
    }

    FEED = {
      :attributes => nil,
      :children =>  { :title => { :dtd => BASIC_ELEMENT,
                                  :mandatory => true,
                                  :maxOccurs => 1},
                      :id =>    { :dtd => BASIC_ELEMENT,
                                  :mandatory => true,
                                  :maxOccurs => 1 },
                      :access => { :dtd => BASIC_ELEMENT,
                                   :mandatory => true,
                                   :maxOccurs => 1},
                      :description => { :dtd => BASIC_ELEMENT,
                                        :mandatory => true,
                                        :maxOccurs => 1 },
                      :published   => { :dtd => BASIC_ELEMENT,
                                        :mandatory => true,
                                        :maxOccurs => 1 },
                      :uri         => { :dtd => BASIC_ELEMENT,
                                        :mandatory => false,
                                        :maxOccurs => 1 },
                      :updated     => { :dtd => BASIC_ELEMENT,
                                        :mandatory => false,
                                        :maxOccurs => 1 },
                      :tags        => { :dtd => TAGS,
                                        :mandatory => false,
                                        :maxOccurs => 1 },
                      :categories  => { :dtd => CATEGORIES,
                                        :mandatory => true,
                                        :maxOccurs => 1 },
                      :dates => { :dtd => DATES,
                                  :mandatory => true,
                                  :maxOccurs => 1 },
                      :places => { :dtd => PLACES,
                                   :mandatory => true,
                                   :maxOccurs => 1 },
                      :prices => { :dtd => PRICES,
                                   :mandatory => false,
                                   :maxOccurs => 1 },
                      :media => { :dtd => MEDIA,
                                  :mandatory => false,
                                  :maxOccurs => 1 },
                      :people => { :dtd => PEOPLE,
                                   :mandatory => false,
                                   :maxOccurs => 1 },
                      :relations => { :dtd => RELATIONS,
                                      :mandatory => false,
                                      :maxOccurs => 1 }
      }
    }

    CHANNEL = {
      :attributes => { :xmlns   => { :mandatory => true,
                                     :maxOccurs => 1},
                       :version => { :mandatory => true,
                                     :maxOccurs => 1},
                       :lang    => { :mandatory => true,
                                     :maxOccurs => 1} },
      :children =>  { :title => { :dtd => BASIC_ELEMENT,
                                  :mandatory => true,
                                  :maxOccurs => 1} ,
                      :link  => { :dtd => BASIC_ELEMENT,
                                  :mandatory => true,
                                  :maxOccurs => 1},
                      :id    => { :dtd => BASIC_ELEMENT,
                                  :mandatory => true,
                                  :maxOccurs => 1 },
                      :published => { :dtd => BASIC_ELEMENT,
                                      :mandatory => true,
                                      :maxOccurs => 1 },
                      :updated => { :dtd => BASIC_ELEMENT,
                                    :mandatory => false,
                                    :maxOccurs => 1 },
                      :generator => { :dtd => BASIC_ELEMENT,
                                      :mandatory => false,
                                      :maxOccurs => 1 },
                      :rights =>   { :dtd => BASIC_ELEMENT,
                                     :mandatory => false,
                                     :maxOccurs => 1},
                      :feed => { :dtd => FEED,
                                 :mandatory => true,
                                 :maxOccurs => :inf }
      }
    }
  end
end

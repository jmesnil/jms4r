# Copyright 2009 Jeff Mesnil (http://jmesnil.net)
#
# This file adds methods to javax.jms.Message proxies
require 'java'

JavaUtilities.extend_proxy('javax.jms.Message') do

  class MessageProperties
    
    def initialize(msg)
      @message = msg
    end
    
    include Enumerable
     def each
       enum = @message.property_names
       while enum.has_more_elements do
         name = enum.next_element
         yield(name, self[name])
       end
       self
     end
     
    def [](key)
      if (@message.property_exists key)
        @message.get_object_property(key)
      else
        nil
      end
    end
    
    def []=(key, value)
      @message.set_object_property(key, value)
    end
    
    def size
      count = 0
      enum = @message.property_names
      while enum.has_more_elements do
        enum.next_element
        count = count + 1
      end
      count
    end
  end
  
  def properties
    @props ||= MessageProperties.new(self)
  end
end
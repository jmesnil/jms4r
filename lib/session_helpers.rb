# Copyright 2009 Jeff Mesnil (http://jmesnil.net)
#
# This file adds methods to javax.jms.Session proxies
require 'java'
require 'jms4r'

JavaUtilities.extend_proxy('javax.jms.Session') do

  def create_message_listener(destination, filter=nil, &handler)
    consumer = self.create_consumer destination, filter
    consumer.set_message_listener JMS::Listener.new(&handler)
    consumer
  end
end
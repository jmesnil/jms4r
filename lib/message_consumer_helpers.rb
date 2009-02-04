# Copyright 2009 Jeff Mesnil (http://jmesnil.net)
#
# This file adds methods to javax.jms.MessageConsumer proxies
require 'java'
require 'jms4r'

JavaUtilities.extend_proxy('javax.jms.MessageConsumer') do

  def on_message(&handler)
    self.set_message_listener JMS::Listener.new(&handler)
  end
end
# Copyright 2009 Jeff Mesnil (http://jmesnil.net)

require 'java'

module JMS

  require 'message_consumer_helpers'

  class Connection
    include_class 'org.jboss.messaging.jms.client.JBossConnectionFactory'
    include_class 'org.jboss.messaging.core.config.TransportConfiguration'

    def initialize
      connector_factory = 'org.jboss.messaging.integration.transports.netty.NettyConnectorFactory'
      connection_factory = JBossConnectionFactory.new TransportConfiguration.new(connector_factory)
      @connection = connection_factory.create_connection
    end

    # Forward all other method messages to the underlying Connection instance.
    def method_missing(method, *args, &block)
      @connection.send method, *args, &block
    end
  end

  class Listener
    include javax.jms.MessageListener

    def initialize(&handler)
      @handler = handler
    end

    def on_message message
      @handler.call message
    end    
  end

end

# Copyright 2009 Jeff Mesnil (http://jmesnil.net)

require 'java'

module JMS

  require 'message_consumer_helpers'

  class Connection
    include_class 'org.jboss.messaging.jms.client.JBossConnectionFactory'
    include_class 'org.jboss.messaging.core.config.TransportConfiguration'

    # creates a connection to a JMS server.
    #
    # connection::  a javax.jms.Connection. If none is passed,
    #               creates a JMS Connection using default JBoss Messaging
    #               configuration
    def initialize(connection=nil)
      @connection = connection || create_jboss_messaging_connection
    end

    def create_jboss_messaging_connection
      connector_factory = 'org.jboss.messaging.integration.transports.netty.NettyConnectorFactory'
      connection_factory = JBossConnectionFactory.new TransportConfiguration.new(connector_factory)
      connection_factory.create_connection
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

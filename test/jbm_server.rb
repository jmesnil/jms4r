# Copyright 2009 Jeff Mesnil (http://jmesnil.net)

module JBossMessaging
    class Server
    include_class 'org.jboss.messaging.core.server.Messaging'
    include_class 'org.jboss.messaging.core.config.impl.ConfigurationImpl'
    include_class 'org.jboss.messaging.core.config.TransportConfiguration'
  
    def initialize
      conf = ConfigurationImpl.new
      conf.security_enabled = false
      acceptor_factory = 'org.jboss.messaging.integration.transports.netty.NettyAcceptorFactory'    
      conf.acceptor_configurations.add TransportConfiguration.new(acceptor_factory)
      @messaging_service = Messaging.new_null_storage_messaging_service conf         
    end
    
    def start
      @messaging_service.start
    end
  
    def stop
      @messaging_service.stop
    end
  end
end

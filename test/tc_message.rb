# Copyright 2009 Jeff Mesnil (http://jmesnil.net)

require "test/unit"

require "jms4r"
require "jbm_server"

class TestMessage < Test::Unit::TestCase

  include_class 'javax.jms.Session'
  
  def setup
    @server = JBossMessaging::Server.new
    @server.start

    @connection = JMS::Connection.new
    @session = @connection.create_session false, Session::AUTO_ACKNOWLEDGE
  end

  def teardown
    @connection.close

    @server.stop
  end

  def test_message_properties
    message = @session.create_message
    
    # there may be some properties already set
    count = message.properties.size
    message.properties["color"] = "black"
    assert_equal count + 1, message.properties.size
    assert_equal "black", message.properties["color"]
  end
  
  def test_message_enumeration
    message = @session.create_message
    # there may be some properties already set
    count = message.properties.size
    
    message.properties["color"] = "black"
    message.properties["speed"] = 88
    
    values = message.properties.map { |k,v| v }
    assert_equal count + 2, values.size
  end
end

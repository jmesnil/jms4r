# Copyright 2009 Jeff Mesnil (http://jmesnil.net)

require "test/unit"

require "jms4r"
require "jbm_server"

class TestMessageListener < Test::Unit::TestCase

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

  def test_message_listener
    text = "hello, world!"

    temp_queue = @session.create_temporary_queue
    assert_not_nil temp_queue

    messages = []
    consumer = @session.create_consumer temp_queue
    
    # the block passed to the on_message method will be called every time
    # the consumer receives a new message
    consumer.on_message {|msg| messages << msg }

    @session.start
    assert_equal 0, messages.size

    producer = @session.create_producer temp_queue
    message = @session.create_text_message text
    producer.send message        
    sleep 1

    assert_equal 1, messages.size
    assert_equal text, messages[0].text
  end
end

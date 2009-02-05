# Copyright 2009 Jeff Mesnil (http://jmesnil.net)

require "test/unit"

require "jms4r"
require "jbm_server"

class TestSession < Test::Unit::TestCase

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

  def test_create_message_listener
    text = "hello, world!"

    temp_queue = @session.create_temporary_queue
    assert_not_nil temp_queue

    messages = []
    consumer = @session.create_message_listener(temp_queue) do |msg| messages << msg end

    @session.start
    assert_equal 0, messages.size

    producer = @session.create_producer temp_queue
    message = @session.create_text_message text
    producer.send message        
    sleep 1

    assert_equal 1, messages.size
    assert_equal text, messages[0].text
  end
  
  def test_create_message_listener_with_filter
    text = "hello, world!"

    temp_queue = @session.create_temporary_queue
    assert_not_nil temp_queue

    messages = []
    consumer = @session.create_message_listener(temp_queue, "color = 'red'") do |msg| messages << msg end

    @session.start
    assert_equal 0, messages.size

    producer = @session.create_producer temp_queue
    blue_message = @session.create_message
    blue_message.properties['color'] = 'blue'
    red_message = @session.create_message
    red_message.properties['color'] = 'red'
    producer.send blue_message        
    producer.send red_message        
    
    sleep 1

    assert_equal 1, messages.size
    assert_equal 'red', messages[0].properties['color']
  end
end

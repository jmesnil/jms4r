# Copyright 2009 Jeff Mesnil (http://jmesnil.net)

require "test/unit"

require "jms4r"
require "jbm_server"

class TestProducerConsumer < Test::Unit::TestCase

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

  def test_produce_consume_single_message
    text = "hello, world!"

    temp_queue = @session.create_temporary_queue
    assert_not_nil temp_queue

    producer = @session.create_producer temp_queue
    message = @session.create_text_message text
    producer.send message

    @session.start

    consumer = @session.create_consumer temp_queue
    receivedMessage = consumer.receive 5000
    assert_not_nil receivedMessage
    assert_equal text, receivedMessage.text
  end

  def test_consume_with_no_message
    temp_queue = @session.create_temporary_queue
    assert_not_nil temp_queue

    @session.start

    consumer = @session.create_consumer temp_queue
    receivedMessage = consumer.receive 5000
    assert_nil receivedMessage
  end
end

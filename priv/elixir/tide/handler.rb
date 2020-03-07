# frozen_string_literal: true

require 'elixir/tide/event'
require 'elixir/tide/exec_event'

module Elixir
  module Tide
    # The Elixir message handler
    class Handler
      include ErlPort::Erlang

      # @since 0.1.0
      attr_reader :server

      # @param server [ErlPort::ErlTerm::OpaqueObject]
      def initialize(server)
        @server = server

        set_message_handler(&method(:process))
      end

      # Send message back to Elixir
      #
      # @param arguments [Array]
      #
      # @since 0.1.0
      def reply(*arguments)
        cast @server, Tuple.new(arguments)
      end

      # Send message to specify GenServer
      #
      # @param server [ErlPort::ErlTerm::OpaqueObject]
      # @param arguments [Array]
      #
      # @since 0.1.0
      def reply_to(server, *arguments)
        cast server, Tuple.new(arguments)
      end

      private

      # The Elixir message handler
      #
      # @since 0.1.0
      def process((type, *args))
        Thread.new do
          begin
            run create_event(type, args)
          rescue RuntimeError => e
            cast @server, Tuple.new([:error, e.message])
          end
        end
      end

      # Create event
      #
      # @param type [String|Symbol] the event type
      # @param event [Array] event arguments
      #
      # @since 0.1.0
      def create_event(type, event)
        return ExecEvent.new(*event) if type == :exec

        Event.new(*event)
      end

      # Run event
      #
      # @param event [Elixir::Tide::Event] the event to execute
      #
      # @since 0.1.0
      def run(event)
        callbacks = Event.find(event.name) || []
        callbacks.each do |callback|
          event.exec(&callback)
        end
      end
    end
  end
end

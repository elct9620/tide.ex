# frozen_string_literal: true

require 'elixir/tide/registry'

module Elixir
  module Tide
    # The Event from Elixir
    class Event
      class << self
        # @since 0.1.0
        LOCK = Mutex.new

        # The events container
        #
        # @return [Elixir::Tide::Registry]
        def registry
          LOCK.synchronize do
            @registry ||= Registry.new
          end
        end

        # Add Event
        #
        # @param name [String|Symbol] the event name
        # @param callback [Proc] the callback
        #
        # @since 0.1.0
        def add_listener(name, &block)
          registry.add(name, &block)
        end

        # Remove Event
        #
        # @param name [String|Symbol] the event name
        # @param callback [Proc] the callback
        def remove_listener(name, &block)
          registry.remove(name, &block)
        end

        # Get event
        #
        # @param name [String|Symbol] the event name
        #
        # @return [Array<Proc>] the event handlers
        def find(name)
          registry.get(name)
        end
      end

      # @since 0.1.0
      attr_reader :name, :target, :state, :reaction

      # @param Handlers [Array<ErlPort::ErlTerm::OpaqueObject>] source handler
      # @param name [String] event name
      # @param args [Array] The arguments
      #
      # @since 0.1.0
      def initialize(handlers, name, args = [])
        @reaction, @state, @target = handlers
        @name = name
        @args = args || []
      end

      # Execute event
      #
      # @param block [Proc] the action to execute
      #
      # @since 0.1.0
      def exec(&block)
        instance_exec(*@args, &block)
      end
    end
  end
end

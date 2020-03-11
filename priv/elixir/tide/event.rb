# frozen_string_literal: true

require 'elixir/tide/registry'
require 'elixir/tide/reaction'
require 'elixir/tide/state'

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

        alias on add_listener

        # Remove Event
        #
        # @param name [String|Symbol] the event name
        # @param callback [Proc] the callback
        def remove_listener(name, &block)
          registry.remove(name, &block)
        end

        alias off remove_listener

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
      def initialize((reaction, state, target), name, args = [])
        @reaction = Reaction.new(reaction)
        @state = State.new(state)
        @target = target
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

      # Create reaction
      #
      # @param name  [String|Symbol] the reaction name
      # @param args [Array] the arguments
      #
      # @since 0.1.0
      def reply(name, *args)
        @reaction.emit(name, *args)
      end
    end
  end
end

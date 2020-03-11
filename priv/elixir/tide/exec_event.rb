# frozen_string_literal: true

require 'elixir/tide/event'

module Elixir
  module Tide
    # The direct execute event
    class ExecEvent < Event
      # @see Event#initialize
      def initialize(handlers, name, args = [])
        super
        @lock = Mutex.new
        @executed = false
      end

      # Execute event once
      #
      # @see Event#execute
      def exec(&block)
        @lock.synchronize do
          return if @executed

          ret = super(&block)
          reply(*ret) unless @executed
        end
      end

      # Create reaction
      #
      # @param name  [String|Symbol] the reaction name
      # @param args [Array] the arguments
      #
      # @since 0.1.0
      def reply(*args)
        return if @executed

        @executed = true
        Tide.handler.reply :ok, @target, *args
      end
    end
  end
end

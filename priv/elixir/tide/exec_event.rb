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

          @executed = true
          Tide.handler.reply :ok, @target, super(&block)
        end
      end
    end
  end
end

# frozen_string_literal: true

module Elixir
  module Tide
    # The thread-safe hash container for event
    class Registry
      # Initialize container with mutex
      #
      # @since 0.1.0
      def initialize
        @lock = Mutex.new
        @items = {}
      end

      # Get a item
      #
      # @param key [String|Symbol] the item to find
      #
      # @return [Array] the results
      #
      # @since 0.1.0
      def get(key)
        @items[key.to_sym].dup.freeze
      end

      # @see Elixir::Tide::Registry#get
      # @since 0.1.0
      alias [] get

      # Register a item
      #
      # @param key [String|Symbol] the item key
      # @param block [Proc] the callback to append
      #
      # @since 0.1.0
      def add(key, &block)
        @lock.synchronize do
          key = key.to_sym
          @items[key] ||= []
          @items[key].push(block)
          true
        end
      end

      # Remove a item
      #
      # @param key [String|Symbol] the item key
      # @param block [Proc] the callback to remove
      #
      # @since 0.1.0
      def remove(key, &block)
        @lock.synchronize do
          key = key.to_sym
          @items[key] ||= []
          @items[key].delete(block)
        end
      end
    end
  end
end

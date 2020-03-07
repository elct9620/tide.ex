# frozen_string_literal: true

module Elixir
  module Tide
    # The reaction manager
    class Reaction
      # @param pid [ErlPort::ErlTerm::OpaqueObject] the reaction pid
      #
      # @since 0.1.0
      def initialize(pid)
        @pid = pid
      end

      # @param name [String|Symbol] the reaction name
      # @param args [Array] the reply to reaction
      #
      # @since 0.1.0
      def emit(name, *args)
        Tide.handler.reply_to @pid, name.to_sym, args
      end
    end
  end
end

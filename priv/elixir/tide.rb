# frozen_string_literal: true

require 'elixir/tide/handler'

module Elixir
  # The Tide between Elixir and Ruby
  module Tide
    include ErlPort::ErlTerm

    class << self
      # @since 0.1.0
      attr_reader :handler

      # @param server [ErlPort::ErlTerm::OpaqueObject] The Tide.Agent GenServer
      # @param ruby [ErlPort::ErlTerm::OpaqueObject] The Ruby GenServer
      #
      # @return [ErlPort::ErlTerm::Tuple] Tuple({:ok, ruby})
      #
      # @since 0.1.0
      def init(server, ruby)
        @handler = Handler.new(server)
        Tuple.new([:ok, ruby])
      end

      # @return [ErlPort::ErlTerm::Atom] :ok
      def ok(*_args)
        :ok
      end
    end
  end
end

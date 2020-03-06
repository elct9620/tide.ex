# frozen_string_literal: true

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

      private

      def process(_args)
        Thread.new do
          begin
            # TODO
          rescue RuntimeError => e
            cast @server, Tuple.new([:error, e.message])
          end
        end
      end
    end
  end
end

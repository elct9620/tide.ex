# frozen_string_literal: true

module Elixir
  module Tide
    # State from Elixir
    class State < Hash
      # @param state_list [Array<ErlPort::ErlTerm::Tuple>] state list
      #
      # @since 0.1.0
      def initialize(state_list)
        state_list.each do |(key, value)|
          self[key] = value
        end
      end
    end
  end
end

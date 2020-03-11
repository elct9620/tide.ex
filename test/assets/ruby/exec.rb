# frozen_string_literal: true

Elixir::Tide.on('use_block') { :ok }
Elixir::Tide.on('use_reply') do
  reply :ok
  reply :error
  :error
end

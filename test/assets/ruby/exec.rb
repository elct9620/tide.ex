# frozen_string_literal: true

Elixir::Tide.on('use_block') { :ok }
Elixir::Tide.on('use_block_arg') { :ok }

Elixir::Tide.on('use_reply') do
  reply :ok
  reply :error
  :error
end

Elixir::Tide.on('use_reply_arg') do |args|
  reply :ok, args
  reply :error
  :error
end

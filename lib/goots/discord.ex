defmodule Goots.Discord do
  @moduledoc """
  Module for handling events from Discord and propogating them to the appropriate child module (ie music player)
  """
  use Nostrum.Consumer
  alias Goots.{Commands, Player}

  def handle_event({:VOICE_SPEAKING_UPDATE, _, _ws_state}) do
    Player.play_next()
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    Commands.message(msg)
  end

  def handle_event(_event) do
    :noop
  end
end

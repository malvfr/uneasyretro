defmodule Retro do
  require Logger

  @moduledoc """
  Retro keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def subscribe(id) do
    Phoenix.PubSub.subscribe(Retro.PubSub, "retro-#{id}")
  end

  def broadcast(id, message) do
    Phoenix.PubSub.broadcast(Retro.PubSub, "retro-#{id}", message)
  end

  def initialize(id, initial_data) do
    Agent.start_link(fn -> initial_data end, name: agent_name(id))
    subscribe(id)
  end

  def get(id) do
    id
    |> agent_name()
    |> Agent.get(& &1)
  end

  def reset_state(id) do
    Agent.update(agent_name(id), fn _state ->
      %{
        went_well_zone: [],
        to_improve_zone: [],
        action_zone: []
      }
    end)
  end

  def update(id, %{
        "draggedId" => card_id,
        "dropzoneId" => to_dropzone,
        "fromId" => from_dropzone,
        "item" => item
      }) do
    card_id = String.to_integer(card_id)

    Agent.update(agent_name(id), fn state ->
      state
      |> IO.inspect(label: "BEFORE")
      |> remove_from_dropzone(String.to_atom(from_dropzone), card_id)
      |> insert_into_dropzone(String.to_atom(to_dropzone), card_id, item)
      |> IO.inspect(label: "AFTER")
    end)
  end

  defp agent_name(id) do
    String.to_atom(id)
  end

  defp remove_from_dropzone(map, from_dropzone, card_id) do
    Map.update!(map, from_dropzone, fn value ->
      Enum.reject(value, &(&1.id == card_id))
    end)
  end

  defp insert_into_dropzone(map, dropzone, card_id, item) do
    Map.update!(map, dropzone, fn elements ->
      [%{id: card_id, title: item["title"], text: item["text"]} | elements]
    end)
  end
end

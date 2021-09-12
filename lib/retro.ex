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
    case Agent.start_link(fn -> initial_data end, name: agent_name(id)) do
      {:ok, _pid} ->
        :ok

      {:error, {:already_started, _pid}} ->
        {:error, :already_started}
    end
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

  def insert(%{"board_lane" => dropzone} = item, id) do
    card_id = System.os_time(:second)

    Agent.update(agent_name(id), fn state ->
      insert_into_dropzone(state, String.to_atom(dropzone), card_id, item)
    end)

    data = get(id)
    broadcast(id, data)
  end

  def remove(%{"card_id" => card_id, "board_lane" => board_lane} = item, id) do
    Logger.debug("Remove item: #{inspect(item)}")

    Agent.update(agent_name(id), fn state ->
      remove_from_dropzone(state, String.to_atom(board_lane), String.to_integer(card_id))
    end)

    data = get(id)
    broadcast(id, data)
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
      |> remove_from_dropzone(String.to_atom(from_dropzone), card_id)
      |> insert_into_dropzone(String.to_atom(to_dropzone), card_id, item)
    end)

    data = get(id)
    broadcast(id, data)
    data
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
      [%{id: card_id, text: item["text"]} | elements]
    end)
  end
end

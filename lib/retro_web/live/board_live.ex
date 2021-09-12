defmodule RetroWeb.BoardLive do
  use RetroWeb, :live_view
  require Logger

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    initial_data = %{
      went_well_zone: [],
      to_improve_zone: [],
      action_zone: []
    }

    Retro.subscribe(id)

    case Retro.initialize(id, initial_data) do
      :ok ->
        socket = assign(socket, cards: initial_data)
        socket = assign(socket, id: id)
        {:ok, socket}

      {:error, :already_started} ->
        Logger.info("Agent already up")
        current_state = Retro.get(id)
        socket = assign(socket, cards: current_state, id: id)
        {:ok, socket}
    end
  end

  @impl true
  def handle_event("dropped", params, %{assigns: %{id: id}} = socket) do
    Logger.debug("HANDLE_EVENT: Dropped #{inspect(params)}")

    Retro.update(id, params)
    {:noreply, fetch(socket)}
  end

  @impl true
  def handle_event(
        "add",
        %{"card_ticket" => data},
        %{assigns: %{id: id}} = socket
      ) do
    Retro.insert(data, id)
    {:noreply, fetch(socket)}
  end

  @impl true
  def handle_event(
        "remove",
        params,
        %{assigns: %{id: id}} = socket
      ) do
    Retro.remove(params, id)
    {:noreply, fetch(socket)}
  end

  @impl true
  def handle_info(msg, socket) do
    Logger.debug("HANDLE_INFO message: #{inspect(msg)}")
    Logger.debug("HANDLE_INFO socket: #{inspect(socket.assigns)}")
    {:noreply, fetch(socket)}
  end

  defp fetch(%{assigns: %{id: id}} = socket) do
    data = Retro.get(id)
    assign(socket, cards: data)
  end
end

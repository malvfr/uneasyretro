defmodule RetroWeb.BoardLive do
  use RetroWeb, :live_view
  require Logger

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    initial_data = %{
      went_well_zone: [
        %{title: "bob 1", id: 1, text: "chopp"}
      ],
      to_improve_zone: [
        %{title: "bob 2", id: 2, text: "chopp"},
        %{title: "bob 3", id: 3, text: "13123"}
      ],
      action_zone: [
        %{title: "bob 4", id: 4, text: "chopp"},
        %{title: "bob 5", id: 5, text: "13123"}
      ]
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
    Logger.debug("HANDLE_EVENT: #{inspect(params)}")

    Retro.update(id, params)
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

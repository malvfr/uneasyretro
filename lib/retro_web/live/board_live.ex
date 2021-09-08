defmodule RetroWeb.BoardLive do
  use RetroWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       went_well_zone: [
         %{title: "bob 1", id: 1, text: "chopp"},
         %{title: "bob 2", id: 2, text: "13123"}
       ],
       to_improve_zone: [
         %{title: "bob 3", id: 3, text: "chopp"},
         %{title: "bob 4", id: 4, text: "13123"}
       ],
       action_zone: [
         %{title: "bob 4", id: 5, text: "chopp"},
         %{title: "bob 6", id: 6, text: "13123"}
       ]
     )}
  end

  @impl true
  def handle_event("create_board", _params, socket) do
    slug = "/boards/" <> MnemonicSlugs.generate_slug()
    {:noreply, push_redirect(socket, to: slug)}
  end

  @impl true
  def handle_event("dropped", params, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end
end

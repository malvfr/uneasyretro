defmodule RetroWeb.PageLive do
  use RetroWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", results: %{})}
  end

  @impl true
  def handle_event("create_board", _params, socket) do
    slug = "/boards/" <> MnemonicSlugs.generate_slug()
    {:noreply, push_redirect(socket, to: slug)}
  end

  @impl true
  def handle_event("join_board", %{"boardId" => board_id}, socket) do
    slug = "/boards/#{board_id}"
    {:noreply, push_redirect(socket, to: slug)}
  end
end

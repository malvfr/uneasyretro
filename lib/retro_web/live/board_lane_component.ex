defmodule RetroWeb.BoardLive.BoardLaneComponent do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~L"""
      <div class="col" style="background-color:<%=@color%>" >
         <div class="row justify-content-center">
          <div
            class="col-md-11"
          >
            <div style="color: white;text-align:center">
            <h1> <%=@title%> </h1>
            </div>

            <div class="dropzone min-vh-100" id="<%=@drop_zone_id%>" style="padding: 10px; border-radius: 10px; background-color: #cccccc40">
              <%= Phoenix.View.render_many @cards, RetroWeb.CardView, "_card.html"%>
            </div>
          </div>
        </div>
       </div>
    """
  end
end

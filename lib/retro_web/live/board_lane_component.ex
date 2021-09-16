defmodule RetroWeb.BoardLive.BoardLaneComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  @impl true
  def render(assigns) do
    ~L"""
      <div class="col-md-4 col-lg-4 col-xs-1 col-sm-4" style="background-color:<%=@color%>" >
         <div class="row justify-content-center">
          <div
            class="col-md-11"
          >
            <hr/>
            <div style="color: white;text-align:center">
              <h1> <%=@title%> </h1>
            </div>
            <hr/>
            <div class="dropzone" id="<%=@drop_zone_id%>" style="padding: 10px; border-radius: 10px; background-color: #cccccc40">
              <div class="d-grid gap-2" x-data="{ open: false }">

                  <button class="btn btn-add" type="button" @click="open = ! open">
                      <i class="fas fa-plus"></i>
                  </button>

                  <div x-show="open" style="background-color: white; border-radius: 8px">
                    <div class="mb-3">
                        <form action="#" phx-submit="add">
                          <%= text_input :card_ticket, :text, placeholder: "What is in your mind?", class: "form-control", required: true %>
                          <%= hidden_input :card_ticket, :board_lane, value: @drop_zone_id %>
                          <div class="btn-group float-end" role="group" aria-label="Basic outlined example">
                            <button class="btn p-1" type="submit">
                              <span style="color:green; font-size: 25px">
                                <i class="fas fa-check"></i>
                              </span>
                            </button>
                            <button class="btn p-1" type="button" @click="open = ! open">
                              <span style="color:red; font-size: 25px">
                                <i class="fas fa-times"></i>
                              </span>
                            </button>
                          </div>
                        </form>
                    </div>
                  </div>
              </div>
              <%= Phoenix.View.render_many @cards, RetroWeb.CardView, "_card.html", board_lane: @drop_zone_id%>
            </div>
          </div>
        </div>
       </div>
    """
  end
end

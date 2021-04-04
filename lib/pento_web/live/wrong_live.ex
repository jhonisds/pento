defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    # IO.inspect(socket, label: "mount")

    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)
    end

    {:ok,
     assign(socket, score: 0, message: "Guess a number", time: time(), number: random_number())}
  end

  def render(assigns) do
    ~L"""
    <h1> Your Score: <%= @score %> </h1>
    <%= @number %>
    <h2>
      <%= @message %>
      It's <%= @time %>
    </h2>
    <h2>
    <%= for n <- 1..10 do %>
      <a href="#" phx-click="guess" phx-value-number="<%= n %>">
        <%= n %>
      </a>
    <% end %>
    </h2>
    """
  end

  def time() do
    DateTime.utc_now()
    |> to_string()
  end

  def random_number(), do: Enum.random(1..10)

  def handle_event("guess", %{"number" => guess} = data, socket) do
    IO.inspect(data)

    message = "Your guess: #{guess} Wrong. Guess again."
    score = socket.assigns.score - 1
    {:noreply, assign(socket, message: message, score: score, time: time())}
  end

  def handle_info(:tick, socket) do
    socket = assign(socket, time: time())
    {:noreply, socket}
  end
end
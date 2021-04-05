defmodule PentoWeb.WrongLive do
  @moduledoc """
  Module wrong live
  """
  use PentoWeb, :live_view

  alias Pento.Accounts

  def mount(_params, session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)
    end

    socket = assign_state(socket, session)
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""

    <h1> Your Score: <%= @score %> </h1>
    <h2>
      <%= @message %>
    </h2>

    <h2>
    <%= for n <- 1..10 do %>
      <a href="#" phx-click="guess" phx-value-number="<%= n %>">
        <%= n %>
      </a>
    <% end %>
    </h2>
    <pre>
      <%= @time %>
      <%= @user.email %>
      <%= @session_id %>
    </pre>
    """
  end

  def time do
    DateTime.utc_now()
    |> Calendar.strftime("%c", preferred_datetime: "%H:%M:%S - %B %-d, %Y")
  end

  def random_number, do: Enum.random(1..10) |> to_string()

  def handle_event("guess", %{"number" => guess}, socket) do
    check_guess(guess, socket)
  end

  def handle_info(:tick, socket) do
    socket = assign(socket, time: time())
    {:noreply, socket}
  end

  defp assign_state(socket, session) do
    socket
    |> assign(
      score: 0,
      message: "Guess a number",
      time: time(),
      number: random_number(),
      user: Accounts.get_user_by_session_token(session["user_token"]),
      session_id: session["live_socket_id"]
    )
  end

  defp check_guess(guess, socket) do
    if guess == socket.assigns.number do
      message = "Your guess: #{guess} Right. Guess again."
      score = socket.assigns.score + 1
      {:noreply, assign(socket, message: message, score: score, number: random_number())}
    else
      message = "Your guess: #{guess} Wrong. Guess again."
      score = socket.assigns.score - 1
      {:noreply, assign(socket, message: message, score: score)}
    end
  end
end

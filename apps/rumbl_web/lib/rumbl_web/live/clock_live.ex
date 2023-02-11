defmodule RumblWeb.ClockLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
      <div>
        <h2>It's <%= to_string(@date) %></h2>
      </div>
    """
  end

  def mount(_session, socket) do
    if connected?(socket),
      do: :timer.send_interval(1000, self(), :tick)

    {:ok, put_date(socket)}
  end

  defp put_date(socket) do
    assign(socket, date: DateTime.utc_now())
  end

  def handle_info(:tick, socket) do
    {:noreply, put_date(socket)}
  end
end

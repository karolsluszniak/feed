defmodule FeedWeb.LatestEntriesLive do
  use FeedWeb, :live_view
  alias Feed.FeedEntries

  @impl true
  def mount(params, session, socket) do
    feed_entries = FeedEntries.list_latest_entries()

    if connected?(socket) do
      Process.send_after(self(), :increase_timer, 1000)
    end

    {:ok, assign(socket, feed_entries: feed_entries, timer: 0)}
  end

  @impl true
  def handle_event("load_new_entries", _params, socket) do
    latest_entry = List.first(socket.assigns.feed_entries)
    new_entries = FeedEntries.list_latest_entries_after(latest_entry.id)
    feed_entries = new_entries ++ socket.assigns.feed_entries

    {:noreply, assign(socket, feed_entries: feed_entries)}
  end

  def handle_event("clear_last_entry", _params, socket) do
    feed_entries =
      socket.assigns.feed_entries
      |> Enum.reverse()
      |> case do
        [_ | rem_entries] -> Enum.reverse(rem_entries)
        [] -> []
      end

    {:noreply, assign(socket, feed_entries: feed_entries)}
  end

  @impl true
  def handle_info(:increase_timer, socket) do
    Process.send_after(self(), :increase_timer, 1000)
    {:noreply, assign(socket, timer: socket.assigns.timer + 1)}
  end
end

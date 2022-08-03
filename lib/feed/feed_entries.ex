defmodule Feed.FeedEntries do
  alias Feed.FeedEntries.FeedEntry

  def list_latest_entries_after(_id) do
    # Simulate the delay for API call
    Process.sleep(1_000)

    [
      generate_entry()
    ]
  end

  def list_latest_entries do
    # Simulate the delay for API call
    Process.sleep(1_000)

    [
      generate_entry(),
      generate_entry()
    ]
  end

  def get_entry_data(_id) do
    # Simulate the delay for transfer of large data
    Process.sleep(1_000)

    generate_entry_data()
  end

  def load_entry_data(entry) do
    %{entry | data: get_entry_data(entry.id)}
  end

  defp generate_entry do
    %FeedEntry{id: generate_entry_id(), data: :not_loaded}
  end

  defp generate_entry_id do
    :crypto.strong_rand_bytes(64)
    |> Base.encode64(padding: false)
    |> binary_part(0, 16)
  end

  defp generate_entry_data do
    [
      %{
        x: [1, 2, 3, 4],
        y: generate_random_values(4),
        type: 'scatter'
      },
      %{
        x: [1, 2, 3, 4],
        y: generate_random_values(4),
        type: 'scatter'
      }
    ]
  end

  defp generate_random_values(n) do
    Enum.map(1..n, fn _ -> generate_random_value() end)
  end

  defp generate_random_value do
    Enum.random(5..30)
  end
end

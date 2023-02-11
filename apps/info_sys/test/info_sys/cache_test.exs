defmodule InfoSys.CacheTest do
  use ExUnit.Case, async: true

  @subject InfoSys.Cache
  @moduletag clear_interval: 100

  setup %{test: name, clear_interval: interval} do
    {:ok, pid} = @subject.start_link(name: name, clear_interval: interval)
    {:ok, name: name, pid: pid}
  end

  test "key value pairs can be put and fetched from cache", %{name: name} do
    assert :ok = @subject.put(name, :key1, :value1)
    assert :ok = @subject.put(name, :key2, :value2)

    assert @subject.fetch(name, :key1) == {:ok, :value1}
    assert @subject.fetch(name, :key2) == {:ok, :value2}
  end

  test "unfound entry returns error", %{name: name} do
    assert @subject.fetch(name, :not_exists) == :error
  end

  test "clears all entries after clear interval", %{name: name} do
    assert :ok = @subject.put(name, :key1, :value1)
    assert @subject.fetch(name, :key1) == {:ok, :value1}
    assert eventually(fn -> @subject.fetch(name, :key1) == :error end)
  end

  @tag clear_interval: 60_000
  test "values are cleaned up on exit", %{name: name, pid: pid} do
    assert :ok = @subject.put(name, :key1, :value1)
    assert_shutdown(pid)

    {:ok, _cache} = @subject.start_link(name: name)
    assert @subject.fetch(name, :key1) == :error
  end

  ##
  # Helpers

  defp assert_shutdown(pid) do
    ref = Process.monitor(pid)
    Process.unlink(pid)
    Process.exit(pid, :kill)

    assert_receive {:DOWN, ^ref, :process, ^pid, :killed}
  end

  defp eventually(func) do
    if func.() do
      true
    else
      Process.sleep(10)
      eventually(func)
    end
  end
end

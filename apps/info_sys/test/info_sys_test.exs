defmodule InfoSysTest do
  use ExUnit.Case, async: true

  alias InfoSys.Result

  defmodule TestBackend do
    def name(), do: "Wolfram"

    def compute("result", _opts) do
      [%Result{backend: __MODULE__, text: "result"}]
    end

    def compute("none", _opts) do
      []
    end

    def compute("timeout", _opts) do
      Process.sleep(:infinity)
    end

    def compute("boom", _opts) do
      raise "boom!"
    end
  end

  describe "compute/2" do
    test "with results" do
      response = InfoSys.compute("result", backends: [TestBackend])
      assert response == [%Result{backend: TestBackend, text: "result"}]
    end

    test "with no backend results" do
      response = InfoSys.compute("none", backends: [TestBackend])
      assert response == []
    end

    test "with timeout returns no result" do
      response = InfoSys.compute("timeout", backends: [TestBackend], timeout: 10)
      assert response == []
    end

    @tag :capture_log
    test "with exception returns no result" do
      assert InfoSys.compute("boom", backends: [TestBackend]) == []
    end
  end
end

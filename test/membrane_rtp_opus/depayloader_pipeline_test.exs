defmodule Membrane.RTP.Opus.DepayloaderPipelineTest do
  use ExUnit.Case

  import Membrane.Testing.Assertions

  alias Membrane.{ParentSpec, Pipeline, RTP, Testing}
  alias Membrane.RTP.Opus.Depayloader

  describe "Depayloader in a pipeline" do
    test "does not crash when processing garbage" do
      base_range = 1..100

      data =
        for elem <- base_range do
          <<elem::256>>
        end

      {:ok, pid} =
        Testing.Pipeline.start_link(
          links:
            ParentSpec.link_linear(
              source: %Testing.Source{output: data, caps: %RTP{}},
              depayloader: Depayloader,
              sink: %Testing.Sink{}
            )
        )

      for elem <- base_range do
        assert_sink_buffer(pid, :sink, %Membrane.Buffer{payload: <<^elem::256>>})
      end

      Pipeline.terminate(pid, blocking?: true)
    end
  end
end

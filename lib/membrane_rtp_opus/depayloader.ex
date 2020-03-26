defmodule Membrane.RTP.Opus.Depayloader do
  @moduledoc """
  Parses RTP payloads into parseable Opus packets.

  Based on [RFC 7587](https://tools.ietf.org/html/rfc7587).
  """

  use Membrane.Filter

  alias Membrane.Caps.RTP
  alias Membrane.Opus

  def_input_pad :input,
    caps: {RTP, payload_type: :dynamic},
    demand_unit: :buffers

  def_output_pad :output,
    caps: Opus.Description

  @impl true
  def handle_process(:input, buffer, _ctx, state) do
    {{:ok, buffer: {:output, buffer}}, state}
  end

  @impl true
  def handle_demand(:output, size, :buffers, _ctx, state) do
    {{:ok, demand: {:input, size}}, state}
  end

  def handle_demand(:output, _size, :bytes, _ctx, state) do
    {{:error, :not_supported_unit}, state}
  end
end

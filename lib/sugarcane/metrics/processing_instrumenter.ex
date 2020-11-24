defmodule Sugarcane.Metrics.ProcessedMessageInstrumenter do
  use Prometheus.Metric

  def setup() do
    Counter.declare(
      name: :sugarcane_processed_messages_total,
      help: "Processed Message Count",
      labels: [:processed]
    )
  end

  def val(), do: Counter.value(name: :sugarcane_processed_messages_total, labels: [:processed])

  def inc do
    Counter.inc(name: :sugarcane_processed_messages_total, labels: [:processed])
  end
end
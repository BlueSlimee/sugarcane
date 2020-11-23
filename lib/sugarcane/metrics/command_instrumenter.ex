defmodule Sugarcane.Metrics.CommandInstrumenter do
  use Prometheus.Metric

  def setup() do
    Counter.declare(
      name: :sugarcane_command_total,
      help: "Command Count",
      labels: [:command]
    )
  end
  
  def inc do
    Counter.inc(name: :sugarcane_command_total, labels: [:command])
  end
end
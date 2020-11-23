defmodule Sugarcane.Metrics do
  def setup do
    Sugarcane.Metrics.PipelineInstrumenter.setup()
    Sugarcane.Metrics.EctoInstrumenter.setup()
    Sugarcane.Metrics.ProcessedMessageInstrumenter.setup()
    Sugarcane.Metrics.CommandInstrumenter.setup()
    Sugarcane.MetricsExporter.setup()
  end
end
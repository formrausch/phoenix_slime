defmodule PhoenixSlime.LiveViewHTMLEngine do
  @behaviour Phoenix.Template.Engine

  @doc """
  Precompiles the String file_path into a function definition
  """
  def compile(path, _name) do
    path
    |> read!()
    |> EEx.compile_string(
      engine: Phoenix.LiveView.HTMLEngine,
      caller: __ENV__,
      source: path,
      file: path,
      line: 1
    )
  end

  defp read!(file_path) do
    file_path
    |> File.read!()
    |> Slime.Renderer.precompile_heex()
  end
end

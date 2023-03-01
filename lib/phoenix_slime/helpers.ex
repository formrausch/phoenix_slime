defmodule PhoenixSlime.Helpers do
  @doc ~S"""
  Outputs the given string as a validated heex template.

  Enables the use of Slime within components' `render/1` function.

      iex> import PhoenixSlime
      iex> assigns = %{world: "world"}
      iex> rendered = ~M[p hello #{@world}]
      %Phoenix.LiveView.Rendered{
        rendered |
        static: ["<p>hello ", "</p>"]
      }
  """
  defmacro sigil_M({:<<>>, meta, [expr]}, _opts) do
    options = [
      source: expr,
      engine: Phoenix.LiveView.HTMLEngine,
      file: __CALLER__.file,
      line: __CALLER__.line + 1,
      module: __CALLER__.module,
      indentation: meta[:indentation] || 0,
      caller: __CALLER__
    ]

    Slime.Renderer.precompile_heex(expr)
    |> EEx.compile_string(options)
  end

  @doc """
  Provides the `~l` sigil with HTML safe Slime syntax inside source files.

  Raises on attempts to use `\#{}`. Use `~L` to allow templating with `\#{}`.

      iex> import PhoenixSlime
      iex> assigns = %{w: "world"}
      iex> ~l"\""
      ...> p = "hello " <> @w
      ...> "\""
      {:safe, ["<p>", "hello world", "</p>"]}
  """
  defmacro sigil_l(expr, opts) do
    handle_sigil(expr, opts, __CALLER__)
  end

  @doc """
  Provides the `~L` sigil for compiling Slime markup into `eex` or `heex` template code.

      iex> import PhoenixSlime
      iex> ~L"\""
      ...> p hello \#{"world"}
      ...> "\""
      {:safe, ["<p>hello ", "world", "</p>"]}
  """
  defmacro sigil_L(expr, opts) do
    handle_sigil(expr, opts, __CALLER__)
  end

  defp handle_sigil({:<<>>, meta, [expr]}, [], caller) do
    options = [
      source: expr,
      engine: Phoenix.HTML.Engine,
      file: caller.file,
      line: caller.line + 1,
      module: caller.module,
      indentation: meta[:indentation] || 0,
      caller: caller
    ]

    expr
    |> Slime.Renderer.precompile()
    |> EEx.compile_string(options)
  end

  defp handle_sigil(_, _, _) do
    raise ArgumentError,
          ~S(Templating is not allowed with #{} in ~l sigil.) <>
            ~S( Remove the #{}, use = to insert values, or ) <>
            ~S(use ~L to template with #{}.)
  end
end

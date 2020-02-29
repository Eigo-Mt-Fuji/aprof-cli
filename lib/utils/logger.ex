defmodule Utils.Logger do
    def debug(message \\ "") do
        case System.get_env("IS_DEBUG") do
            nil -> nil
            _ -> IO.puts(message)
        end
    end
end

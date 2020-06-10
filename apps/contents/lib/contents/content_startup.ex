defmodule Contents.ContentStartup do
    use GenServer
    require Logger
  
    def start_link(state \\ []) do
      GenServer.start_link(__MODULE__, state)
    end
  
    @impl true
    def init(state) do
        define_contents_root()
        {:ok, state}
    end

    def define_contents_root do
        case File.mkdir("/opt/kopio_contents") do
            :ok ->
                Logger.info("/opt/kopio_contents Created")
                {:reply, "/opt/kopio_contents Created"}
            {:error, :eexist} ->
                Logger.info("/opt/kopio_contents Exist")
                {:reply, "/opt/kopio_contents Exist"}
            _ ->
                Logger.error("/opt/kopio_contents Failed To Create")
                {:reply, "/opt/kopio_contents Failed To Create"}
        end
    end

    def static_path do
        "/opt/kopio_contents"
    end
end
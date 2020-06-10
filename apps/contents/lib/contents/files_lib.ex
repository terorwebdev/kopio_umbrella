defmodule Contents.Files_lib do
    alias Contents.Files
    require Logger
    ## File Action
    def file_rename(path) do
        #cannot rename dir if dir have data inside
        #cannot rename if file is used at playlist
    end

    def file_copy(path) do
    end

    def file_move(path) do
        #cannot rename dir if dir have data inside
        #cannot rename if file is used at playlist
    end

    def file_delete(path) do
        #cannot rename dir if dir have data inside
        #cannot rename if file is used at playlist
    end

    def file_path(id) do 
        case id do
            "root" ->
                {:ok, "/"}
            _ ->
                case Files.id_exist(id) do 
                file ->
                    {:ok, Enum.join([file.path, file.filename], "/")}
                nil ->
                    {:error, "id not exist"}
                end
        end
    end

    def create_dir(target) do
        File.mkdir_p!(target)
    end

    def copy_temp_static(from, to) do
        case File.cp(from, to) do
            :ok ->
                Logger.info("Success copy")
                {_, size} = file_size(to)
                {_, format} = format_type(to)
                {:ok , size, format}
            _ ->
                :error
        end
    end

    ## File Details
    def file_size(path) do
        case  File.stat path do
            {:ok, size} ->
                {:size, size.size}
            {:error, _} ->
                {:size, 0}
        end
    end

    def format_type(path) do
        status = MIME.from_path(path)
        case String.split(status, "/") do
            [type, _]->
                {:format, type}
            _ ->
                {:format, ""}
        end
    end

    def file_resolution(type, file) do
        info = Atom.to_charlist(String.to_atom(file))
        case type do
            "image" ->
                command = 'mediainfo --Inform="Image;%Width%,%Height%" "'++info++'"'
                file_resolution_cmd(command)
            "video" ->
                command = 'mediainfo --Inform="Video;%Width%,%Height%" "'++info++'"'
                file_resolution_cmd(command)
            _ ->
                {:resolution, "0x0"}
        end
    end

    def file_resolution_cmd(command) do
        case :os.cmd(command) do
            '\n' ->
                {:resolution, "0x0"}
            data ->
                [filter] = String.split(to_string(data), ~r{\n}, trim: true)
                {:resolution, String.replace(filter, ",","x")}
        end
    end

    def file_duration(type, file) do
        info = Atom.to_charlist(String.to_atom(file))
        case type do
            "video" ->
                command = 'mediainfo --Inform="Video;%Duration%" "'++info++'"'
                file_resolution_cmd(command)
            "audio" ->
                command = 'mediainfo --Inform="Audio;%Duration%" "'++info++'"'
                file_resolution_cmd(command)
            _ ->
                {:duration, "0"}
        end
    end

    def file_duration_cmd(command) do
        case :os.cmd(command) do
            '\n' ->
                {:duration, "0"}
            data ->
                [filter] = String.split(to_string(data), ~r{\n}, trim: true)
                case Integer.parse(filter) do
                    {_, ""} ->
                        {:duration, String.to_integer(filter)}
                    _ -> 
                        {:duration, round(String.to_float(filter))}
                end     
        end
    end

end
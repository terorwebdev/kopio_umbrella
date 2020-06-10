defmodule Contents.Files.File do
  use Ecto.Schema
  import Ecto.Changeset

  schema "files" do
    field :filename, :string
    field :format, :string
    field :parent_id, :string
    field :path, :string
    field :size, :integer
    field :type, :string
    field :upload_by, :string

    timestamps()
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, [:parent_id, :type, :path, :size, :format, :filename, :upload_by])
    |> validate_required([:parent_id, :type, :path, :filename, :upload_by])
  end
end

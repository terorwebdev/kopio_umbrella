defmodule Contents.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :parent_id, :string
      add :type, :string
      add :path, :string
      add :format, :string
      add :size, :integer
      add :filename, :string
      add :upload_by, :string

      timestamps()
    end

  end
end

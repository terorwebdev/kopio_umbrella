defmodule Assets.Repo.Migrations.CreateBlogPosts do
  use Ecto.Migration

  def change do
    create table(:blog_posts) do
      add :tags, {:array, :string}

      timestamps()
    end

  end
end

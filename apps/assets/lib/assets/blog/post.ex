defmodule Assets.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "blog_posts" do
    field :tags, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:tags])
    |> validate_required([:tags])
  end
end

defmodule Extemporize.Repo.Migrations.AddUniqueIndexToRedirectPattern do
  use Ecto.Migration

  def change do
    create unique_index(:redirects, [:pattern])
  end
end

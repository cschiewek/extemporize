defmodule Extemporize.Repo.Migrations.CreateRedirect do
  use Ecto.Migration

  def change do
    create table(:redirects) do
      add :domain, :string
      add :path, :string
      add :destination, :string

      timestamps
    end

    create index(:redirects, [:domain])
    create index(:redirects, [:path])
    create unique_index(:redirects, [:domain, :path])
  end
end

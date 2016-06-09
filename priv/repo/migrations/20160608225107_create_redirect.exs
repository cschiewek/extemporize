defmodule Extemporize.Repo.Migrations.CreateRedirect do
  use Ecto.Migration

  def change do
    create table(:redirects) do
      add :pattern, :string
      add :destination, :string

      timestamps
    end

  end
end

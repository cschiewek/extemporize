defmodule Mix.Tasks.Extemporize.Gen.Data do
  use Mix.Task
  alias Extemporize.{Repo, Redirect}

  @shortdoc "Generates fake data for testing purposes."

  def run(_) do
    Mix.Task.run "app.start", []
    generate
  end

  defp generate do
    Repo.insert! %Redirect{domain: "localhost", path: "/first", destination: "/end"}
    for _ <- 1..1000 do
      Repo.insert! %Redirect{domain: "localhost", path: "/#{random_string}", destination: "/#{random_string}"}
    end
    Repo.insert! %Redirect{domain: "localhost", path: "/last", destination: "/end"}
  end

  defp random_string, do: :crypto.strong_rand_bytes(10) |> Base.url_encode64 |> binary_part(0, 10)
end

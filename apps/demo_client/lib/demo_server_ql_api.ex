defmodule DemoServerQLApi do
  use CommonGraphQLClient.Context,
    otp_app: :demo_client

  def subscribe do
    # NOTE: This will call __MODULE__.receive(:employee_created, employee) when data is received
    client().subscribe_to(:employee_created, __MODULE__)

    # (optional) synchronize on reconnect
    # NOTE: This is better in a Task
    list!(:employees)
    |> sync_employees()
  end

  def receive(subscription_name, %{id: id, email: email}) when subscription_name in [:employee_created] do
    import Ecto.Query, warn: false
    alias DemoClient.{Cache.Timesheet, Repo}

    query = from t in Timesheet,
              where: t.employee_email == ^email and is_nil(t.employee_id)

    Repo.all(query)
    |> Enum.each(fn(timesheet) ->
      timesheet
      |> Ecto.Changeset.change(employee_id: id)
      |> Repo.update!()
    end)
  end

  # This is just a POC. In reality, you'd want to handle deleted records and this would probably be an employee_updated event.
  def sync_employees(employees) do
    IO.puts "Beginning Re-connection Sync"

    employees
    |> Enum.each(fn(employee) -> receive(:employee_created, employee) end)

    IO.puts "Completed Re-connection Sync"
  end

end

defmodule DemoServerQLApi.Query.Employee do
  @moduledoc """
  Employee GraphQL queries
  """

  @doc false
  def list do
    """
    query {
      employees {
        id
        name
        email
      }
    }
    """
  end

  def get_by(%{id: _}) do
    """
    query get_employee($id: ID!) {
      employee(id: $id) {
        id
        name
        email
      }
    }
    """
  end

  def get_by(%{email: _}) do
    """
    query get_employee($email: String) {
      employee(email: $email) {
        id
        name
      }
    }
    """
  end
end

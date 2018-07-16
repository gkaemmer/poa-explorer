defmodule ExplorerWeb.AddressTransactionView do
  use ExplorerWeb, :view

  import ExplorerWeb.AddressView, only: [contract?: 1, smart_contract_verified?: 1]

  def format_current_filter(filter) do
    case filter do
      "to" -> gettext("To")
      "from" -> gettext("From")
      _ -> gettext("All")
    end
  end

  def address_template(address, token_transfer) do
    cond do
      address.hash == token_transfer.from_address_hash -> "_from_address.html"
      address.hash == token_transfer.to_address_hash -> "_to_address.html"
      contract?(address) -> "_contract_address.html"
    end
  end
end

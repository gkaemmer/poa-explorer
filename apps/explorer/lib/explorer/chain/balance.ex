defmodule Explorer.Chain.Balance do
  @moduledoc """
  The `t:Explorer.Chain.Weit.t/0` `value` of `t:Explorer.Chain.Address.t/0` at the end of a `t:Explorer.Chain.Block.t/0`
  `t:Explorer.Chain.Block.block_number/0`.
  """

  use Explorer.Schema

  alias Explorer.Chain.{Address, Block, Hash, Wei}

  @required_fields ~w(address_hash block_number value)a

  @typedoc """
   * `address` - the `t:Explorer.Chain.Address.t/0` with `value` at end of `block_number`.
   * `address_hash` - foreign key for `address`.
   * `block_number` - the `t:Explorer.Chain.Block.block_number/0` for the `t:Explorer.Chain.Block.t/0` at the end of
       which `address` had `value`.
   * `inserted_at` - When the balance was first inserted into the database.
   * `updated_at` - When the balance was last updated.
   * `value` - the value of `address` at the end of the `t:Explorer.Chain.Block.block_number/0` for the
       `t:Explorer.Chain.Block.t/0`.
  """
  @type t :: %__MODULE__{
          address: %Ecto.Association.NotLoaded{} | Address.t(),
          address_hash: Hash.Address.t(),
          block_number: Block.block_number(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t(),
          value: Wei.t()
        }

  @primary_key false
  schema "balances" do
    field(:block_number, :integer)
    field(:value, Wei)

    timestamps()

    belongs_to(:address, Address, foreign_key: :address_hash, references: :hash, type: Hash.Address)
  end

  def changeset(%__MODULE__{} = balance, params) do
    balance
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:address_hash)
    |> unique_constraint(:block_number, name: :balances_address_hash_block_number_index)
  end
end

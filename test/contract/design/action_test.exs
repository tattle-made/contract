defmodule Contract.Design.ActionTest do
  alias Contract.Design.Action
  use ExUnit.Case

  test "open_trade/1" do
    attrs = %{
      "from_id" => "player_asdfasdf",
      "to_id" => "player_wbewe",
      "card_id" => "card_adf3fsd"
    }

    action = Action.open_trade(attrs)
    assert action.type == :open_trade
    assert action.payload != nil

    attrs_b = %{
      "to_id" => "player_wbewe",
      "card_id" => "card_adf3fsd"
    }

    action_b = Action.open_trade(attrs_b)
  end

  test "accept_trade/1" do
    attrs = %{
      "from_id" => "player_asdfadsf",
      "to_id" => "player_webdsd",
      "card_id" => "card_asdfndd"
    }

    action = Action.accept_trade(attrs)
    assert action.type == :accept_trade
    assert action.payload != nil
  end
end

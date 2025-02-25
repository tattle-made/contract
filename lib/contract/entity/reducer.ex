defmodule Contract.Entity.Reducer do
  alias Contract.Entity.PlayerMap
  alias Contract.Entity.Trade.NoOpenTrade
  alias Contract.Entity.Trade
  alias Contract.Design.Action
  alias Contract.Entity.State

  def reduce(%State{} = state, %Action{type: :open_trade} = action) do
    %{from_id: from_id, to_id: to_id, card_id: card_id} = action.payload
    card = state.players[from_id].hand |> Enum.find(&(&1.id == card_id))

    trade = %Trade{type: :open, card: card, from: from_id, to: to_id}
    %{state | trades: state.trades ++ [trade]}
  end

  def reduce(%State{} = state, %Action{type: :accept_trade, payload: payload} = action) do
    %{from_id: from_id, to_id: to_id, card_id: card_id} = payload

    case Enum.find(state.trades, nil, &(&1.from == to_id && &1.to == from_id)) do
      nil ->
        raise NoOpenTrade

      %Trade{} = open_trade ->
        #  delete open trade
        trades =
          state.trades
          |> List.delete(open_trade)

        # swap cards in player's hands
        players = state.players

        open_player = players[open_trade.from]
        open_card = PlayerMap.card_in_hand(open_player, open_trade.card.id)
        accepting_player = players[from_id]
        accepting_card = PlayerMap.card_in_hand(accepting_player, card_id)

        players =
          players
          |> PlayerMap.remove_from_hand(open_player.id, open_card)
          |> PlayerMap.add_to_hand(open_player.id, accepting_card)
          |> PlayerMap.remove_from_hand(accepting_player.id, accepting_card)
          |> PlayerMap.add_to_hand(accepting_player.id, open_card)

        %{state | players: players, trades: trades}
    end
  end
end

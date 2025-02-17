defmodule Contract.Factory do
  alias Contract.Entity.Card, as: EntityCard
  alias Contract.Canon.Card

  def make_random_card_entity() do
    card = Card.random()

    %EntityCard{
      id: card.id,
      shape: card.shape,
      property: card.property
    }
  end

  def make_card_entity_from(%Card{} = canon_card) do
    %EntityCard{
      id: canon_card.id,
      shape: canon_card.shape,
      property: canon_card.property
    }
  end
end

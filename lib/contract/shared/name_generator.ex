defmodule Contract.Shared.NameGenerator do
  def name() do
    adjectives = [
      "ambitious",
      "basic",
      "careful",
      "dark",
      "eager",
      "fab",
      "glib",
      "happy",
      "inept",
      "jolly",
      "keen",
      "lavish",
      "magic",
      "neat",
      "official",
      "perfect",
      "quack",
      "rare",
      "sassy",
      "tall",
      "velvet",
      "weak"
    ]

    nouns = [
      "apple",
      "ball",
      "cat",
      "dog",
      "eel",
      "fish",
      "goat",
      "hen",
      "island",
      "joker",
      "lion",
      "monk",
      "nose",
      "oven",
      "parrot",
      "queen",
      "rat",
      "sun",
      "tower",
      "umbrella",
      "venus",
      "water",
      "zebra"
    ]

    Enum.random(adjectives) <> "-" <> Enum.random(nouns)
  end
end

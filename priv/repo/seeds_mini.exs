# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Coscul.Repo.insert!(%Coscul.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Mix.Task.run("ecto.rollback")
Mix.Task.run("ecto.migrate")

alias Coscul.Repo

alias Coscul.Data.{Item, Recipe, RecipeTerm, RecipeCategory, Factory}
iron_ore = Repo.insert!(%Item{name: "鉄鉱石", stack: 50, is_liquid: false, order: 0})
copper_ore = Repo.insert!(%Item{name: "銅鉱石", stack: 50, is_liquid: false, order: 1})
iron_plate = Repo.insert!(%Item{name: "鉄板", stack: 100, is_liquid: false, order: 2})
copper_plate = Repo.insert!(%Item{name: "銅板", stack: 100, is_liquid: false, order: 3})
copper_wire = Repo.insert!(%Item{name: "銅線", stack: 200, is_liquid: false, order: 4})
electronic_circuit = Repo.insert!(%Item{name: "電子基板", stack: 200, is_liquid: false, order: 5})

recipe_category_mining = Repo.insert!(%RecipeCategory{name: "採掘"})
recipe_category_furnace = Repo.insert!(%RecipeCategory{name: "精錬"})
recipe_category_assembler = Repo.insert!(%RecipeCategory{name: "組立"})

hand =
  Repo.insert!(%Factory{
    name: "手動組立",
    can_input_liquid: false,
    crafting_speed: 1.0,
    recipe_category_id: recipe_category_assembler.id
  })

assembler_1 =
  Repo.insert!(%Factory{
    name: "組立機1",
    can_input_liquid: false,
    crafting_speed: 0.5,
    recipe_category_id: recipe_category_assembler.id
  })

assembler_2 =
  Repo.insert!(%Factory{
    name: "組立機2",
    can_input_liquid: true,
    crafting_speed: 0.75,
    recipe_category_id: recipe_category_assembler.id
  })

assembler_3 =
  Repo.insert!(%Factory{
    name: "組立機3",
    can_input_liquid: true,
    crafting_speed: 1.25,
    recipe_category_id: recipe_category_assembler.id
  })

mining_iron =
  Repo.insert!(%Recipe{time: 2.0, recipe_category_id: recipe_category_mining.id, order: 0})

Repo.insert!(%RecipeTerm{value: 1, item_id: iron_ore.id, recipe_id: mining_iron.id})

mining_copper =
  Repo.insert!(%Recipe{time: 2.0, recipe_category_id: recipe_category_mining.id, order: 1})

Repo.insert!(%RecipeTerm{value: 1, item_id: copper_ore.id, recipe_id: mining_copper.id})

burning_iron =
  Repo.insert!(%Recipe{time: 3.2, recipe_category_id: recipe_category_furnace.id, order: 2})

Repo.insert!(%RecipeTerm{value: -1, item_id: iron_ore.id, recipe_id: burning_iron.id})
Repo.insert!(%RecipeTerm{value: 1, item_id: iron_plate.id, recipe_id: burning_iron.id})

burning_copper =
  Repo.insert!(%Recipe{time: 3.2, recipe_category_id: recipe_category_furnace.id, order: 3})

Repo.insert!(%RecipeTerm{value: -1, item_id: copper_ore.id, recipe_id: burning_copper.id})
Repo.insert!(%RecipeTerm{value: 1, item_id: copper_plate.id, recipe_id: burning_copper.id})

drawing_wire =
  Repo.insert!(%Recipe{time: 0.5, recipe_category_id: recipe_category_assembler.id, order: 4})

Repo.insert!(%RecipeTerm{value: -1, item_id: copper_plate.id, recipe_id: drawing_wire.id})
Repo.insert!(%RecipeTerm{value: 2, item_id: copper_wire.id, recipe_id: drawing_wire.id})

assemble_circuit =
  Repo.insert!(%Recipe{time: 1.25, recipe_category_id: recipe_category_assembler.id, order: 5})

Repo.insert!(%RecipeTerm{value: -1, item_id: iron_plate.id, recipe_id: assemble_circuit.id})
Repo.insert!(%RecipeTerm{value: -3, item_id: copper_wire.id, recipe_id: assemble_circuit.id})

Repo.insert!(%RecipeTerm{value: 1, item_id: electronic_circuit.id, recipe_id: assemble_circuit.id})

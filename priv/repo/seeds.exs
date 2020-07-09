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

Mix.Task.run("ecto.drop")
Mix.Task.run("ecto.create")
Mix.Task.run("ecto.migrate")

alias Coscul.Repo

alias Coscul.Data.{Item, Recipe, RecipeTerm, RecipeCategory}

iron_ore = Repo.insert!(%Item{name: "鉄鉱石", stack: 50})
iron_plate = Repo.insert!(%Item{name: "鉄板", stack: 100})
copper_ore = Repo.insert!(%Item{name: "銅鉱石", stack: 50})
copper_plate = Repo.insert!(%Item{name: "銅板", stack: 100})
copper_wire = Repo.insert!(%Item{name: "銅線", stack: 200})
electronic_circuit = Repo.insert!(%Item{name: "電子基板", stack: 200})
iron_gear_wheel = Repo.insert!(%Item{name: "歯車", stack: 100})
science_pack_1 = Repo.insert!(%Item{name: "サイエンスパック1", stack: 200})
science_pack_2 = Repo.insert!(%Item{name: "サイエンスパック2", stack: 200})

recipe_category_furnace = Repo.insert!(%RecipeCategory{name: "炉"})
recipe_category_assembler = Repo.insert!(%RecipeCategory{name: "組立機"})
recipe_category_assembler_and_hand = Repo.insert!(%RecipeCategory{name: "組立機+手"})

burning_iron = Repo.insert!(%Recipe{time: 3.2, recipe_category_id: recipe_category_furnace.id})
Repo.insert!(%RecipeTerm{value: -1, item_id: iron_ore.id, recipe_id: burning_iron.id})
Repo.insert!(%RecipeTerm{value: 1, item_id: iron_plate.id, recipe_id: burning_iron.id})

burning_copper = Repo.insert!(%Recipe{time: 3.2, recipe_category_id: recipe_category_furnace.id})
Repo.insert!(%RecipeTerm{value: -1, item_id: copper_ore.id, recipe_id: burning_copper.id})
Repo.insert!(%RecipeTerm{value: 1, item_id: copper_plate.id, recipe_id: burning_copper.id})

drawing_wire =
  Repo.insert!(%Recipe{time: 0.5, recipe_category_id: recipe_category_assembler_and_hand})

Repo.insert!(%RecipeTerm{value: -1, item_id: copper_plate.id, recipe_id: drawing_wire.id})
Repo.insert!(%RecipeTerm{value: 2, item_id: copper_wire.id, recipe_id: drawing_wire.id})

assemble_circuit =
  Repo.insert!(%Recipe{time: 1.25, recipe_category_id: recipe_category_assembler_and_hand})

Repo.insert!(%RecipeTerm{value: -1, item_id: iron_plate.id, recipe_id: assemble_circuit.id})
Repo.insert!(%RecipeTerm{value: -2, item_id: copper_wire.id, recipe_id: assemble_circuit.id})

Repo.insert!(%RecipeTerm{value: 1, item_id: electronic_circuit.id, recipe_id: assemble_circuit.id})

assemble_iron_gear_wheel =
  Repo.insert!(%Recipe{time: 0.5, recipe_category_id: recipe_category_assembler.id})

Repo.insert!(%RecipeTerm{
  value: -2,
  item_id: iron_plate.id,
  recipe_id: assemble_iron_gear_wheel.id
})

Repo.insert!(%RecipeTerm{
  value: 1,
  item_id: iron_gear_wheel.id,
  recipe_id: assemble_iron_gear_wheel.id
})

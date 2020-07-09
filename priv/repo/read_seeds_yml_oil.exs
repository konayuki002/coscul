Mix.Task.run("ecto.rollback")
Mix.Task.run("ecto.migrate")
Coscul.ImportYml.insert_rows_from_yml("./priv/repo/seeds_oil.yml")

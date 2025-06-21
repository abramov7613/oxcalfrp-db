local sqlite3 = require("lsqlite3")
local db = sqlite3.open_memory()

db:exec[[
  create table "псалом" (
    "номер"        INTEGER not null,
    "часть"        INTEGER not null,
    "кафизма"      INTEGER not null,
    "слава"        INTEGER not null,
    "текст_ру"     TEXT    not null,
    "текст_цс"     TEXT    not null,
    "заголовок_ру" TEXT            ,
    "заголовок_цс" TEXT            ,
    constraint псалом_id primary key ("номер","часть")
  );
]]

function add_psalom(t)
  db:exec(
    string.format("INSERT INTO \"псалом\" VALUES (%d, %d, %d, %d, \"%s\", \"%s\", \"%s\", \"%s\");",
                    t["номер"],
                    t["часть"],
                    t["кафизма"],
                    t["слава"],
                    t["текст_ру"],
                    t["текст_цс"],
                    t["заголовок_ру"],
                    t["заголовок_цс"]
    )
  )
end

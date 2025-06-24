local sqlite3 = require("lsqlite3")
local db = sqlite3.open_memory()

db:exec[[
  create table псалом (
    номер        INTEGER not null,
    часть        INTEGER not null,
    кафизма      INTEGER not null,
    слава        INTEGER not null,
    текст_ру     TEXT    not null,
    текст_цс     TEXT    not null,
    заголовок_ру TEXT            ,
    заголовок_цс TEXT            ,
    constraint псалом_id primary key (номер,часть)
  )   ;

  create table книга (
    книга_id   INTEGER PRIMARY KEY,
    название   TEXT    not null,
    возглас_ру TEXT            ,
    возглас_цс TEXT
  )   ;

  create table зачало_евангелия (
    комментарий         TEXT    PRIMARY KEY,
    номер               INTEGER not null,
    книга_id            INTEGER not null,
    текст_ру            TEXT    not null,
    текст_цс            TEXT    not null
  )   ;

  create table зачало_апостола (
    комментарий        TEXT    PRIMARY KEY,
    номер              INTEGER not null,
    книга_id           INTEGER not null,
    текст_ру           TEXT    not null,
    текст_цс           TEXT    not null
  )   ;
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

function add_book(t)
  local vr = t["возглас_ру"]
  local vc = t["возглас_цс"]
  if not vr then vr = "NULL" end
  if not vc then vc = "NULL" end
  db:exec(
    string.format("INSERT INTO \"книга\" VALUES (NULL, \"%s\", \"%s\", \"%s\");",
                    t["название"],
                    vr,
                    vc
    )
  )
end

function add_evangelie_matfea(t)
  db:exec(
    string.format("INSERT INTO \"зачало_евангелия\" VALUES (\"%s\", %d, (SELECT книга_id FROM книга WHERE название=\"евангелие от матфея\"), \"%s\", \"%s\");",
                    t["комментарий"],
                    t["номер"],
                    t["текст_ру"],
                    t["текст_цс"]
    )
  )
end

function add_evangelie_marka(t)
  db:exec(
    string.format("INSERT INTO \"зачало_евангелия\" VALUES (\"%s\", %d, (SELECT книга_id FROM книга WHERE название=\"евангелие от марка\"), \"%s\", \"%s\");",
                    t["комментарий"],
                    t["номер"],
                    t["текст_ру"],
                    t["текст_цс"]
    )
  )
end

function add_evangelie_luki(t)
  db:exec(
    string.format("INSERT INTO \"зачало_евангелия\" VALUES (\"%s\", %d, (SELECT книга_id FROM книга WHERE название=\"евангелие от луки\"), \"%s\", \"%s\");",
                    t["комментарий"],
                    t["номер"],
                    t["текст_ру"],
                    t["текст_цс"]
    )
  )
end

function add_evangelie_ioanna(t)
  db:exec(
    string.format("INSERT INTO \"зачало_евангелия\" VALUES (\"%s\", %d, (SELECT книга_id FROM книга WHERE название=\"евангелие от иоанна\"), \"%s\", \"%s\");",
                    t["комментарий"],
                    t["номер"],
                    t["текст_ру"],
                    t["текст_цс"]
    )
  )
end

-- function add_apostol(t)

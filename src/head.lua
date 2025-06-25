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

  create table ирмос (
    ирмос_id        INTEGER PRIMARY KEY,
    глас            INTEGER not null,
    текст_ру        TEXT    not null,
    текст_цс        TEXT    not null
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
  local book_id = "SELECT книга_id FROM книга WHERE название=\"евангелие от матфея\""
  db:exec(
    string.format("INSERT INTO \"зачало_евангелия\" VALUES (\"%s\", %d, (%s), \"%s\", \"%s\");",
                    t["комментарий"],
                    t["номер"],
                    book_id,
                    t["текст_ру"],
                    t["текст_цс"]
    )
  )
end

function add_evangelie_marka(t)
  local book_id = "SELECT книга_id FROM книга WHERE название=\"евангелие от марка\""
  db:exec(
    string.format("INSERT INTO \"зачало_евангелия\" VALUES (\"%s\", %d, (%s), \"%s\", \"%s\");",
                    t["комментарий"],
                    t["номер"],
                    book_id,
                    t["текст_ру"],
                    t["текст_цс"]
    )
  )
end

function add_evangelie_luki(t)
  local book_id = "SELECT книга_id FROM книга WHERE название=\"евангелие от луки\""
  db:exec(
    string.format("INSERT INTO \"зачало_евангелия\" VALUES (\"%s\", %d, (%s), \"%s\", \"%s\");",
                    t["комментарий"],
                    t["номер"],
                    book_id,
                    t["текст_ру"],
                    t["текст_цс"]
    )
  )
end

function add_evangelie_ioanna(t)
  local book_id = "SELECT книга_id FROM книга WHERE название=\"евангелие от иоанна\""
  db:exec(
    string.format("INSERT INTO \"зачало_евангелия\" VALUES (\"%s\", %d, (%s), \"%s\", \"%s\");",
                    t["комментарий"],
                    t["номер"],
                    book_id,
                    t["текст_ру"],
                    t["текст_цс"]
    )
  )
end

function add_apostol(t)
  local comment = t["комментарий"]
  local book_id = ""
  if string.find(comment, "^Деян") then
    book_id = "SELECT книга_id FROM книга WHERE название=\"Деяния святых Апостолов\""
  elseif string.find(comment, "^Иак") then
    book_id = "SELECT книга_id FROM книга WHERE название=\"Послание Иаковле\""
  elseif string.find(comment, "^1 Пет") then
    book_id = "SELECT книга_id FROM книга WHERE название=\"Послание первое святаго апостола Петра\""
  elseif string.find(comment, "^2 Пет") then
    book_id = "SELECT книга_id FROM книга WHERE название=\"Послание второе святаго апостола Петра\""
  elseif string.find(comment, "^1 Ин") then
    book_id = "SELECT книга_id FROM книга WHERE название=\"Послание первое святаго апостола Иоанна Богослова\""
  elseif string.find(comment, "^2 Ин") then
    book_id = "SELECT книга_id FROM книга WHERE название=\"Послание второе святаго апостола Иоанна Богослова\""
  elseif string.find(comment, "^3 Ин") then
    book_id = "SELECT книга_id FROM книга WHERE название=\"Послание третье святаго апостола Иоанна Богослова\""
  elseif string.find(comment, "^Иуд") then
    book_id = "SELECT книга_id FROM книга WHERE название=\"Послание Иудино\""
  elseif string.find(comment, "^Рим") then
    book_id = "SELECT книга_id FROM книга WHERE название=\"Послание к Римлянам Апостола Павла\""
  elseif string.find(comment, "^1 Кор") then
    book_id = "SELECT книга_id FROM книга WHERE название=\"Первое Послание к Коринфянам Апостола Павла\""
  elseif string.find(comment, "^2 Кор") then
    book_id = "SELECT книга_id FROM книга WHERE название=\"Второе Послание к Коринфянам Апостола Павла\""
  elseif string.find(comment, "^Гал") then
    book_id = "SELECT книга_id FROM книга WHERE название=\"Послание к Галатам Апостола Павла\""
  elseif string.find(comment, "^Еф") then
    book_id = "SELECT книга_id FROM книга WHERE название=\"Послание к Ефесянам Апостола Павла\""
  elseif string.find(comment, "^Флп") then
    book_id = "SELECT книга_id FROM книга WHERE название=\"Послание к Филиппийцам Апостола Павла\""
  elseif string.find(comment, "^Кол") then
    book_id = "SELECT книга_id FROM книга WHERE название=\"Послание к Колоссянам Апостола Павла\""
  elseif string.find(comment, "^1 Сол") then
    book_id = "SELECT книга_id FROM книга WHERE название=\"Первое Послание к Фессалоникийцам Апостола Павла\""
  elseif string.find(comment, "^2 Сол") then
    book_id = "SELECT книга_id FROM книга WHERE название=\"Второе Послание к Фессалоникийцам Апостола Павла\""
  elseif string.find(comment, "^1 Тим") then
    book_id = "SELECT книга_id FROM книга WHERE название=\"Первое Послание к Тимофею Апостола Павла\""
  elseif string.find(comment, "^2 Тим") then
    book_id = "SELECT книга_id FROM книга WHERE название=\"Второе Послание к Тимофею Апостола Павла\""
  elseif string.find(comment, "^Тит") then
    book_id = "SELECT книга_id FROM книга WHERE название=\"Послание к Титу Апостола Павла\""
  elseif string.find(comment, "^Флм") then
    book_id = "SELECT книга_id FROM книга WHERE название=\"Послание к Филимону Апостола Павла\""
  elseif string.find(comment, "^Евр") then
    book_id = "SELECT книга_id FROM книга WHERE название=\"Послание к Евреям Апостола Павла\""
  end
  assert(#book_id ~= 0)
  db:exec(
    string.format("INSERT INTO \"зачало_апостола\" VALUES (\"%s\", %d, (%s), \"%s\", \"%s\");",
                    comment,
                    t["номер"],
                    book_id,
                    t["текст_ру"],
                    t["текст_цс"]
    )
  )
end

function add_irmos(t)
  db:exec(
    string.format("INSERT INTO \"ирмос\" VALUES (NULL, %d, \"%s\", \"%s\");",
                    t["глас"],
                    t["текст_ру"],
                    t["текст_цс"]
    )
  )
end

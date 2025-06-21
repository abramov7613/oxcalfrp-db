local vacuum_command = string.format("VACUUM INTO \"%s\"", arg[1])
db:exec (vacuum_command)

require! <[tape ../src/index]>

tape 'function definition' -> it
  ..is typeof index, \function
  ..end!

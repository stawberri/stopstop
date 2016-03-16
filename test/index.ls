require! <[tape ../src/index nock util]>

tape 'function definition' -> it
  ..is typeof index, \function
  ..end!

nock-host = \https://api.telegram.org/

tape 'simple use case' (t) ->
  token = "t#{Math.random!}"
  data =
    chat_id: "i#{Math.random!}"
    text: "t#{Math.random!}"

  n = nock nock-host
    .post "/bot#{token}/sendMessage", -> it === data
    .reply 200, ->
      t
        ..pass 'expected request sent'
        ..end!
      nock.clean-all!

  t.timeout-after 500
  index token, data.chat_id, data.text

tape 'curry api token' (t) ->
  token = "t#{Math.random!}"
  data =
    chat_id: "i#{Math.random!}"
    text: "t#{Math.random!}"

  n = nock nock-host
    .post "/bot#{token}/sendMessage", -> it === data
    .reply 200, ->
      t
        ..pass 'expected request sent'
        ..end!
      nock.clean-all!

  t.timeout-after 500
  curry = index token
  curry data.chat_id, data.text

tape 'curry api token and recipient together' (t) ->
  token = "t#{Math.random!}"
  data =
    chat_id: "i#{Math.random!}"
    text: "t#{Math.random!}"

  n = nock nock-host
    .post "/bot#{token}/sendMessage", -> it === data
    .reply 200, ->
      t
        ..pass 'expected request sent'
        ..end!
      nock.clean-all!

  t.timeout-after 500
  curry = index token, data.chat_id
  curry data.text

tape 'curry api token and recipient separately' (t) ->
  token = "t#{Math.random!}"
  data =
    chat_id: "i#{Math.random!}"
    text: "t#{Math.random!}"

  n = nock nock-host
    .post "/bot#{token}/sendMessage", -> it === data
    .reply 200, ->
      t
        ..pass 'expected request sent'
        ..end!
      nock.clean-all!

  t.timeout-after 500
  curry = index token
  curry = curry data.chat_id
  curry data.text

tape 'more complicated outputs' (t) ->
  token = "t#{Math.random!}"

  test-string = "s#{Math.random!} %j #{Math.random!}s"
  test-data =
    "a#{Math.random!}": "aa#{Math.random!}"
    "b#{Math.random!}": "bb#{Math.random!}"
    "c#{Math.random!}": "cc#{Math.random!}"
    "d#{Math.random!}": "dd#{Math.random!}"

  data =
    chat_id: "i#{Math.random!}"
    text: util.format test-string, test-data

  n = nock nock-host
    .post "/bot#{token}/sendMessage", -> it === data
    .reply 200, ->
      t
        ..pass 'expected request sent'
        ..end!
      nock.clean-all!

  t.timeout-after 500
  index token, data.chat_id, test-string, test-data

tape 'function chaining' (t) ->
  token = "t#{Math.random!}"
  data =
    chat_id: "i#{Math.random!}"
    text: "t#{Math.random!}"
  data-alt =
    chat_id: data.chat_id
    text: "t#{Math.random!}"

  remaining = 2
  check = ->
    unless --remaining
      t
        ..pass 'expected requests sent'
        ..end!
      nock.clean-all!

  n = nock nock-host
    .post "/bot#{token}/sendMessage", -> it === data
    .reply 200, check
    .post "/bot#{token}/sendMessage", -> it === data-alt
    .reply 200, check

  t.timeout-after 500
  chain = index token, data.chat_id, data.text
  chain data-alt.text

tape 'full parameter specifying' (t) ->
  token = "t#{Math.random!}"
  data =
    chat_id: "i#{Math.random!}"
  test-data =
    text: "t#{Math.random!}"
    "a#{Math.random!}": "aa#{Math.random!}"
    "b#{Math.random!}": "bb#{Math.random!}"
    "c#{Math.random!}": "cc#{Math.random!}"
    "d#{Math.random!}": "dd#{Math.random!}"
  data <<< test-data

  n = nock nock-host
    .post "/bot#{token}/sendMessage", -> it === data
    .reply 200, ->
      t
        ..pass 'expected request sent'
        ..end!
      nock.clean-all!

  t.timeout-after 500
  index token, data.chat_id, index, test-data

tape 'full parameter currying' (t) ->
  token = "t#{Math.random!}"
  data =
    chat_id: "i#{Math.random!}"
  test-data =
    text: "t#{Math.random!}"
    "a#{Math.random!}": "aa#{Math.random!}"
    "b#{Math.random!}": "bb#{Math.random!}"
    "c#{Math.random!}": "cc#{Math.random!}"
    "d#{Math.random!}": "dd#{Math.random!}"
  data <<< test-data

  n = nock nock-host
    .post "/bot#{token}/sendMessage", -> it === data
    .reply 200, ->
      t
        ..pass 'expected request sent'
        ..end!
      nock.clean-all!

  t.timeout-after 500
  curry = index token, data.chat_id, index
  curry test-data

tape 'full parameter chaining' (t) ->
  token = "t#{Math.random!}"

  data =
    chat_id: "i#{Math.random!}"
  test-data =
    text: "t#{Math.random!}"
    "a#{Math.random!}": "aa#{Math.random!}"
    "b#{Math.random!}": "bb#{Math.random!}"
    "c#{Math.random!}": "cc#{Math.random!}"
    "d#{Math.random!}": "dd#{Math.random!}"
  data <<< test-data

  data-alt =
    chat_id: data.chat_id
  test-data-alt =
    text: "t#{Math.random!}"
    "a#{Math.random!}": "aa#{Math.random!}"
    "b#{Math.random!}": "bb#{Math.random!}"
    "c#{Math.random!}": "cc#{Math.random!}"
    "d#{Math.random!}": "dd#{Math.random!}"
  data-alt <<< test-data-alt

  remaining = 2
  check = ->
    unless --remaining
      t
        ..pass 'expected requests sent'
        ..end!
      nock.clean-all!

  n = nock nock-host
    .post "/bot#{token}/sendMessage", -> it === data
    .reply 200, check
    .post "/bot#{token}/sendMessage", -> it === data-alt
    .reply 200, check

  t.timeout-after 500
  chain = index token, data.chat_id, index, test-data
  chain test-data-alt

tape 'remove bot from beginning of token' (t) ->
  token = "tle#{Math.random!}"
  token-test = "/bot#{token}"
  data =
    chat_id: "i#{Math.random!}"
    text: "t#{Math.random!}"

  n = nock nock-host
    .post "/bot#{token}/sendMessage", -> it === data
    .reply 200, ->
      t
        ..pass 'expected request sent'
        ..end!
      nock.clean-all!

  t.timeout-after 500
  index token-test, data.chat_id, data.text

tape 'first two arguments must be defined' (t) ->
  token = "t#{Math.random!}"
  data =
    chat_id: "i#{Math.random!}"
    text: util.format!

  t
    ..throws index, 'nothing specified'
    ..throws (index token), 'only token specified'

  n = nock nock-host
    .post "/bot#{token}/sendMessage", -> it === data
    .reply 200, ->
      t
        ..pass 'expected request sent'
        ..end!
      nock.clean-all!

  t.timeout-after 500
  (index token, data.chat_id)!

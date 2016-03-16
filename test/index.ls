require! <[tape ../src/index nock util]>

tape 'function definition' -> it
  ..is typeof index, \function
  ..end!

nock-host = \https://api.telegram.org/

tape 'simple use case' (t) ->
  token = "#{Math.floor 999999999 * Math.random!}:token_test"
  data =
    chat_id: "
      #{if Math.random! < 0.5 then '-' else ''}
      #{Math.floor 999999999 * Math.random!}
    "
    text: "t#{Math.random!}"

  n = nock nock-host
    .post "/bot#{token}/sendMessage", -> it === data
    .reply 200, ->
      t
        ..pass 'expected request sent'
        ..end!
      nock.clean-all!

  t.timeout-after 500
  t.comment data.chat_id
  index token, data.chat_id, data.text

tape 'curry api token' (t) ->
  token = "#{Math.floor 999999999 * Math.random!}:token_test"
  data =
    chat_id: "
      #{if Math.random! < 0.5 then '-' else ''}
      #{Math.floor 999999999 * Math.random!}
    "
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
  token = "#{Math.floor 999999999 * Math.random!}:token_test"
  data =
    chat_id: "
      #{if Math.random! < 0.5 then '-' else ''}
      #{Math.floor 999999999 * Math.random!}
    "
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
  token = "#{Math.floor 999999999 * Math.random!}:token_test"
  data =
    chat_id: "
      #{if Math.random! < 0.5 then '-' else ''}
      #{Math.floor 999999999 * Math.random!}
    "
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
  token = "#{Math.floor 999999999 * Math.random!}:token_test"

  test-string = "s#{Math.random!} %j #{Math.random!}s"
  test-data =
    "a#{Math.random!}": "aa#{Math.random!}"
    "b#{Math.random!}": "bb#{Math.random!}"
    "c#{Math.random!}": "cc#{Math.random!}"
    "d#{Math.random!}": "dd#{Math.random!}"

  data =
    chat_id: "
      #{if Math.random! < 0.5 then '-' else ''}
      #{Math.floor 999999999 * Math.random!}
    "
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
  token = "#{Math.floor 999999999 * Math.random!}:token_test"
  data =
    chat_id: "
      #{if Math.random! < 0.5 then '-' else ''}
      #{Math.floor 999999999 * Math.random!}
    "
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
  data =
    text: "t#{Math.random!}"
  test-data =
    chat_id: "
      #{if Math.random! < 0.5 then '-' else ''}
      #{Math.floor 999999999 * Math.random!}
    "
    "a#{Math.random!}": "aa#{Math.random!}"
    "b#{Math.random!}": "bb#{Math.random!}"
    "c#{Math.random!}": "cc#{Math.random!}"
    "d#{Math.random!}": "dd#{Math.random!}"
  options =
    token: "t#{Math.random!}"
    params: test-data
  data <<< test-data

  n = nock nock-host
    .post "/bot#{token}/sendMessage", -> it === data
    .reply 200, ->
      t
        ..pass 'expected request sent'
        ..end!
      nock.clean-all!

  t.timeout-after 500
  index options, data.text

tape 'full parameter currying' (t) ->
  data =
    text: "t#{Math.random!}"
  test-data =
    chat_id: "
      #{if Math.random! < 0.5 then '-' else ''}
      #{Math.floor 999999999 * Math.random!}
    "
    "a#{Math.random!}": "aa#{Math.random!}"
    "b#{Math.random!}": "bb#{Math.random!}"
    "c#{Math.random!}": "cc#{Math.random!}"
    "d#{Math.random!}": "dd#{Math.random!}"
  options =
    token: "t#{Math.random!}"
    params: test-data
  data <<< test-data

  n = nock nock-host
    .post "/bot#{token}/sendMessage", -> it === data
    .reply 200, ->
      t
        ..pass 'expected request sent'
        ..end!
      nock.clean-all!

  t.timeout-after 500
  curry = index options
  curry data.text

tape 'full parameter chaining' (t) ->
  data =
    text: "t#{Math.random!}"
  data-alt =
    text: "t#{Math.random!}"
  test-data =
    chat_id: "
      #{if Math.random! < 0.5 then '-' else ''}
      #{Math.floor 999999999 * Math.random!}
    "
    "a#{Math.random!}": "aa#{Math.random!}"
    "b#{Math.random!}": "bb#{Math.random!}"
    "c#{Math.random!}": "cc#{Math.random!}"
    "d#{Math.random!}": "dd#{Math.random!}"
  options =
    token: "t#{Math.random!}"
    params: test-data
  data <<< test-data
  data-alt <<< test-data

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
  chain = index options, data.text
  chain data-alt.text

tape 'extract tokens from urls' (t) ->
  token = "tle#{Math.random!}"
  token-test = "https://api.telegram.org/bot#{token}/sendMessage"
  data =
    chat_id: "
      #{if Math.random! < 0.5 then '-' else ''}
      #{Math.floor 999999999 * Math.random!}
    "
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

tape 'empty function calling' (t) ->
  token = "#{Math.floor 999999999 * Math.random!}:token_test"
  data =
    chat_id: "
      #{if Math.random! < 0.5 then '-' else ''}
      #{Math.floor 999999999 * Math.random!}
    "
    text: util.format!

  t
    ..throws index, 'no parameters'
    ..throws (stopme = stopstop token), 'with token'
    ..throws (stopit = stopme data.chat_id), 'with id'
    ..throws (stopitobj = index {}), 'with object'

  remaining = 2
  check = ->
    unless --remaining
      t
        ..pass 'expected requests sent'
        ..end!
      nock.clean-all!
  n = nock nock-host
    .post "/bot#{token}/sendMessage", -> it === data
    .times 2
    .reply 200, -> check

  t.timeout-after 500
  stopit!
  stopitobj!

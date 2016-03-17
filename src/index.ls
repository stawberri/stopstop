require! <[request util extend]>

module.exports = ->
  switch typeof it
  | \string => curry ...
  | \object => stoptions ...
  | _       => throw new Error 'First parameter must be options or a token'
curry = (token, chat_id) --> stoptions {token, params: {chat_id}}, ...&[2 to -1]
stoptions = ->
  options = extend true, {}, it
  throw new Error "Missing 'token' option" unless options.token?
  if options.token is /(?:bot)?(\d+:[-\w]+)/
    options.token = that.1
  else
    throw new Error "Invalid token: #{options.token}"
  throw new Error "Missing 'params' option" unless options.params?
  throw new Error "Missing 'chat_id' parameter" unless options.params.chat_id?
  unless isNaN chat_id = parse-int options.params.chat_id
    options.params.chat_id = chat_id
  else
    throw new Error "Invalid chat_id: #{options.params.chat_id}"
  stopit = ->
    request.post do
      url: "https://api.telegram.org/bot#{options.token}/sendMessage"
      form: extend true, {}, options.params, text: util~format ...
      ->
    stopit
  |> (-> it)
    ..now = -> stoptions (extend true, {}, options, it), ...&[1 to -1]
    .. ...&[1 to -1] if &length > 1

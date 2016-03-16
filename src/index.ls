require! <[request util]>

stop = (token, chat_id, options) -->
  request.post do
    uri: "https://api.telegram.org/bot#{token}/sendMessage"
    form: {} <<< options <<< {chat_id}
    ->
  stop token, chat_id

module.exports = (token, chat_id, output) -->
  return module.exports unless token?
  token .= trim!
  token = that.1 if token is /^(?:(?:.*\/)?bot)?([^\/]*)(?:\/.*)?$/
  return module.exports token unless chat_id?

  return stop token, chat_id, ...&[3 to -1] if output is module.exports
  stop token, chat_id, text: util.format ...&[2 to -1]
  module.exports token, chat_id

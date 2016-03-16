require! <[request util]>

stop = (token, chat_id, options) -->
  request.post do
    uri: "https://api.telegram.org/bot#{token}/sendMessage"
    form: {} <<< options <<< {chat_id}
    ->
  stop token, chat_id

module.exports = (token, chat_id, output) -->
  if token is /^(?:(?:.*\/)?bot)?([^\/]*)(?:\/.*)?$/
    token = that.1
  else
    throw new Error 'Missing api token'

  throw new Error 'Missing chat id' unless chat_id?

  return stop token, chat_id, ...&[3 to -1] if output is module.exports
  stop token, chat_id, text: util.format ...&[2 to -1]
  module.exports token, chat_id

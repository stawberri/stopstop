require! <[request util]>

stop = (token, recipient, options) -->
  request.post do
    uri: "https://api.telegram.org/bot#{token}/sendMessage"
    form: {} <<< options <<< chat_id: recipient
    ->
  stop token, recipient

module.exports = (token, recipient, output) -->
  token = that.1 if token is /^\/?bot(.*)$/
  return stop token, recipient, ...&[3 to -1] if output is module.exports
  stop token, recipient, text: util.format ...&[2 to -1]
  module.exports token, recipient

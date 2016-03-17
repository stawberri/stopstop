# stopstop
simple telegram output passer

[![NPM](https://nodei.co/npm/stopstop.png?mini=true)](https://nodei.co/npm/stopstop/)
[![Build Status](https://travis-ci.org/stawberri/stopstop.svg?branch=master)](https://travis-ci.org/stawberri/stopstop)

stopstop is like `console.log` over Telegram messages. Its one function package means you don't need to fumble with a full bot-making api just to send yourself error logs from a script you're too busy to watch all the time. It's named after the way historical telegrams used `STOP` instead of periods.

```javascript
stopstop = require('stopstop');

stopit = stopstop('<token>', 123456789);
stopit('Meow~');
```

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Passing output](#passing-output)
  - [stopstop(token, chat_id, data[, ...])](#stopstoptoken-chat_id-data-)
  - [stopstop(token, chat_id)](#stopstoptoken-chat_id)
  - [stopstop(token)](#stopstoptoken)
- [More options](#more-options)
  - [stopstop(options, data[, ...])](#stopstopoptions-data-)
  - [stopstop(options)](#stopstopoptions)
  - [stopit.now(options)](#stopitnowoptions)
- [Making a bot and finding your chat id](#making-a-bot-and-finding-your-chat-id)
  - [Getting a telegram bot's api token](#getting-a-telegram-bots-api-token)
  - [Getting your chat id](#getting-your-chat-id)
- [Curried functions](#curried-functions)
  - [Chaining stopstop](#chaining-stopstop)
- [It's just like `console.log`!](#its-just-like-consolelog)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Passing output
stopstop is a curried function. It expects three parameters, but if you pass it any less than that, it'll give you a new function that takes the rest of the parameters instead of giving you an error. Rather than having to provide all of the parameters at once, you can provide a couple first and save its return value to provide the rest of them later.I'll be referring to these partial functions as `stopme` and `stopit`.

```javascript
// A stopstop that has been given a token is a stopme
stopme = stopstop('<token>');

// A stopstop that has been given a token and a chat_id is a stopit
stopit = stopme(123456789);

// A stopit sends messages over Telegram
stopit('Telegraphic! ♥');
```

### stopstop(token, chat_id, data[, ...])
This is the fully applied version of stopstop. Passing all three (or more) arguments to stopstop completes a stopstop call, which sends your `data` over to your specified `chat_id` from the bot who owns your specified `token`.

* `token` _string_. Your bot's api token! Your messages will come from the bot this corresponds to.
* `chat_id` _number_. This is where you specify who you want your bot to send messages to.
* `data` _anything_. Just think of this part as the arguments you would pass to `console.log` and you'll be fine!
* `...` _anything_. Just like `console.log`, you can actually pass multiple data arguments and they'll get strung together!
* **returns** _stopit_. You get another `stopit` back, which means you can actually save the return value from any complete stopstop call to make more stopstop calls with the same settings!

Alternate forms: `stopme(chat-id, data[, ...])` `stopit(data[, ...])`  
Similar: [`stopstop(options, data[, ...])`](#stopstopoptions-data-)

### stopstop(token, chat_id)
This is stopstop without being given output data. You probably actually want to create this version of stopstop at the top of your script, and then call the function it returns just like you usually use `console.log`. It's probably the best way to use stopstop, so it's what the example at the very top shows!

* `token` _string_. Your bot's api token! Your messages will come from the bot this corresponds to.
* `chat_id` _number_. This is where you specify who you want your bot to send messages to.
* **returns** _stopit_. This gives you a `stopit`, which is what you use to send messages on Telegram!

Alternate form:  `stopme(chat-id)`
Similar: [stopstop(options)](#stopstopoptions)

### stopstop(token)
This is what happens when you pass stopstop only an api token. It's not as useful as passing it both a `token` and a `chat_id`, but it might still have some uses, such as when you have a script that might want to notify multiple people about things.
* `token` _string_. Your bot's api token! Your messages will come from the bot this corresponds to.
* **returns** _stopme_. You can use a `stopme` to specify what chats you would like your bot to send messages to. Note that you can actually pass both `chat_id` and `data` to a `stopme` at the same time, so creating a `stopme` doesn't force you to make three function calls.

## More options
You may find stopstop's default configuration a little limiting. After all, it doesn't really give you much control over formatting or other options. That's because I wanted to keep things simple, but thanks to curry magic, stopstop has an alternate form that _does_ give you more choices!

```javascript
stopit = stopstop({
    token: '<token>',
    params: {
        chat_id: 123456789,
        parse_mode: 'markdown'
    }
});
stopit("Well, who's being **a little bold** now?");
```

### stopstop(options, data[, ...])
You'll notice that `options`, an object, is completely different from the string `token` that stopstop's other form expects as a first parameter. That's how stopstop knows which version you want. As far as stopstop is concerned, providing an `options` object replaces the first two parameters of its other form. There isn't any difference beyond that.
* `options` _object_. Make choices about what you want stopstop to do!
    - `token` _string_. Your bot's api token! Your messages will come from the bot this corresponds to.
    - `params` _object_. This object is passed directly to Telegram's bot API as request parameters, so you probably wannya look at [their sendMessage reference](https://core.telegram.org/bots/api#sendmessage) for more details.
        + `chat_id` _number_. This is where you specify who you want your bot to send messages to.
        + `text` _nothing_. While you _can_ set a text parameter and stopstop won't throw an error, there's no point in doing so because it'll get overwritten.
* `data` _anything_. Just think of this part as the arguments you would pass to `console.log` and you'll be fine!
* `...` _anything_. Just like `console.log`, you can actually pass multiple data arguments and they'll get strung together!
* **returns** _stopit_. You get another `stopit` back, which means you can actually save the return value from any complete stopstop call to make more stopstop calls with the same settings!

Similar: [`stopstop(token, chat_id, data[, ...])`](#stopstoptoken-chat_id-data-)

### stopstop(options)
Just like the other form of stopstop, you can curry this form too! Since it only takes two parameters it's a lot less exciting, but you probably wannya set options and send messages as separate steps, so it's still pretty important. **Note that while _parameters_ are curried, _options_ are not.** Giving stopstop `options` that do not contain both a `token` and a `params.chat_id` will throw an error.
* `options` _object_. Make choices about what you want stopstop to do!
* **returns** _stopit_. This gives you a `stopit`, which is what you use to send messages on Telegram!

Similar: [`stopstop(token, chat_id)`](#stopstoptoken-chat_id)

### stopit.now(options)
Changed your mind about what you wanted your `stopit`'s options to be but you don't wannya start over? Change them with this! Remember that it returns an entirely _new_ `stopit` without modifying your old one, so save its return value!
* `options` _object_. Make choices about what you want stopstop to do!
* **returns** _stopit_. This gives you a `stopit`, which is what you use to send messages on Telegram!

## Making a bot and finding your chat id
Before you can start using stopstop, you will need a Telegram bot and the chat ids of the chat you wish to have your bot notify.

### Getting a telegram bot's api token
This part is easy. Just talk to [BotFather](https://telegram.me/BotFather) and follow his directions for making a new bot. He'll give you an api key and you'll be good to go. If you already have a bot and you forgot its api token, BotFather can help you with that as well. Yay!

### Getting your chat id
This is a little harder, and requires a bit of manual API work.

1. Send your Telegram bot a message. If you can't think of anything, `/start` actually counts as a message for this step, so you're probably already good to go.

2. Navigate to this url in your browser (an api request tester of your choice), replacing `<token>` with your bot's api token.

   ```
   https://api.telegram.org/bot<token>/getUpdates
   ```

3. If you're familiar with json, you'll find a couple objects containing your user details, including an `id` parameter. That's your chat id! If you're not familiar with json, just use your browser's search feature to search for your username, your name on Telegram, or even the message you sent your bot. Inside that tangle of brackets, you should be able to find a `"id": some-number` field that's pretty close to the rest of your user data. That's what you're looking for.

    ```json
    "from": {
      "id": 123456789,
      "first_name": "Your",
      "last_name": "Name",
      "username": "YourUsername"
    }
    ```

## Some more examples
You can send all sorts of things with stopstop!

```javascript
stopit = stopstop('<token>')(123456789)('Oh, for the love of curry!');

stopit('meow')('nyaa')('purr');
stopit('multiple', 'parameters', '!!');
stopit(/lots of options/);
stopit(Math.floor(100000000 * Math.random()));
stopit({objects: 'and'}, ['arrays'], {both: ['at', 'once', '?!']});
stopit(function() {return 'When would you ever need to log a function?';});
stopit('stopstop uses %s on its parameters.', 'util.format');
stopit(undefined);
stopit();
```

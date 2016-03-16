# stopstop
simple telegram output passer

[![NPM](https://nodei.co/npm/stopstop.png?mini=true)](https://nodei.co/npm/stopstop/)
[![Build Status](https://travis-ci.org/stawberri/stopstop.svg?branch=master)](https://travis-ci.org/stawberri/stopstop)

This is a module to simplify using Telegram's bot API as a simple DIY alternative to services like [Pushover](https://pushover.net/) or [Pushbullet](https://pushbullet.com/). It's named after the way historical telegrams used `STOP` in place of periods.

```javascript
var stopstop = require('stopstop');
```

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Making a bot and finding your chat id](#making-a-bot-and-finding-your-chat-id)
  - [Getting a telegram bot's api token](#getting-a-telegram-bots-api-token)
  - [Getting your chat id](#getting-your-chat-id)
- [Basic usage](#basic-usage)
  - [stopstop(token[, chatId[, data[, ...]]])](#stopstoptoken-chatid-data-)
  - [stopstop(token, chatId, stopstop[, options])](#stopstoptoken-chatid-stopstop-options)
- [Curried functions](#curried-functions)
  - [Chaining stopstop](#chaining-stopstop)
- [It's just like `console.log`!](#its-just-like-consolelog)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

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
      "username": "your_username"
    }
    ```

## Basic usage
stopstop takes three parameters: your bot's api token, your chat id, and whatever you wish to send. That last part sounds pretty vague, and that's because it is! After those first two required parameters, you can pass just about anything you would wannya pass to `console.log` to stopstop!

```javascript
stopstop('<token>', 123456789, "Hi! I'm a debug message!");
```

### stopstop(token[, chatId[, data[, ...]]])
Have the Telegram bot with your provided token send data to your specified chat id. Note that stopstop doesn't accept a callback, because your script doesn't actually get notified if it succeeded or not! Seeing that the whole point of this is to notify _you_, it just seems kinda redundant. You might also notice that nearly all of stopstop's parameters are optional in a really weird, nested way. That's because it's curried! If you're not sure what that means, keep reading~
* `token` _string_. Your bot's api token! Your messages will come from the bot this corresponds to.
* `chatId` _number_. This is where you specify who you want your bot to send messages to.
* `data` _anything_. Just think of this part as the arguments you would pass to `console.log` and you'll be fine!

### stopstop(token, chatId, stopstop[, options])
You're probably wondering why I'm providing documentation for the same function twice, and why `stopstop` is being passed to itself. Since you can pass _anything_ as `data`, I needed some way for you to signify that you wanted this version of stopstop! This function is _also_ curried, which is why options is optional.
* `options` _object_. If you ever feel like you want a little more control of what your bot sends, this object allows you to specify what stopstop sends to Telegram! You'll wannya refer to [Telegram's sendMessage reference](https://core.telegram.org/bots/api#sendmessage) to learn more about what you can provide in options. Don't worry about providing `chat_id`.

```javascript
stopstop("<token>", 123456789, stopstop, {
    text: "Oh, I'm so *bold*~",
    parse_mode: 'markdown'
});
```

## Curried functions
I said above that stopstop is curried, and you might be wondering what currying is. The idea is pretty simple: stopstop actually requires at least three parameters (while stopstop's second variation requires four). If you pass less than this number of parameters to stopstop, stopstop will return a new version of itself with these functions filled in!

```javascript
stopme = stopstop("<token>", 123456789);
stopme("Hi! I'm a debug message!");
```

That's literally all there is to it! It allows you to define your api token and chat id once and never need to worry about it again!

### Chaining stopstop
This isn't something curried functions usually do, but stopstop actually also returns itself even when you specify all the arguments! This lets you chain stopstop. Unfortunately, there aren't any guarantees that you'll receive these messages in order, so try to write them so that they don't sound weird if they arrive in a different order!

```javascript
stopme = stopstop("<token>", 123456789, "Hi! I'm a debug message!");
stopme('I have so many things to say.')("Here's another message for you~");
```

## It's just like `console.log`!
I really did mean it when I said that it's just like `console.log`, by the way! The only thing that you can't pass stopstop as data is stopstop itself.

```javascript
stopme = stopstop("<token>", 123456789, "Hi! I'm a debug message!");

stopme('multiple', 'parameters!');
stopme(['arrays', 'too', '!']);
stopme({objects: 'and'}, ['arrays'], {both: ['at', 'once', '?!']});
stopme(function() {return 'When would you ever need to log a function?';});
stopme([stopstop, 'If you really HAD to send yourself stopstop.']);
stopme('Guessed it? stopstop uses %s on its parameters.', 'util.format');
```

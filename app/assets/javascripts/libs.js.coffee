# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

posts = []
count = 0

$ ->
  $.ajax(
    url: 'http://api.tumblr.com/v2/tagged?filter=text&limit=60&tag=longreads&api_key=9yvK620NKUswptyIM6zUrruq4ZptNM1GVGrmuUSHgWFJws1aek'
    dataType: 'jsonp'
    success: (data) ->
      for post in data.response
        if count < 6
          if post.type == "text"
            posts.push post
            count++
        else
          break
      post = posts[Math.floor(Math.random() * posts.length)].body
      $.ajax(
        url: 'http://access.alchemyapi.com/calls/text/TextGetRelations?apikey=94b629cfbcff4d82104d6f253b074874a80dc29a'
        type: 'POST'
        data:
          text: post.substring 0, 500
          outputMode: 'json'
        dataType: 'jsonp'
        success: (parsed) ->
          console.log parsed
      )
   )

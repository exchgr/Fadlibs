# Add all the app-wide coffeescript here.

# Facebook auth
window.fbAsyncInit = ->
  FB.init
    appId: "367333956679167" # App ID
    channelUrl: "http://localhost:3000/" # Channel File
    status: true # check login status
    cookie: true # enable cookies to allow the server to access the session
    xfbml: true # parse XFBML
$('header').on 'click', '.fb-login-button', ->
  FB.login (user) ->
    if user.authResponse
      $(".fb-login-button").hide()
      console.log "Welcome!  Fetching your information.... "
      FB.api "/me", (user) ->
        console.log "Good to see you, " + user.name + "."
        if user
          image = document.getElementById('image');
          image.src = 'http://graph.facebook.com/' + user.id + '/picture';
          name = document.getElementById('name');
          name.innerHTML = user.name
    else
      console.log "User cancelled login or did not fully authorize."
      
# Additional initialization code here

# Load the SDK Asynchronously
((d) ->
  js = undefined
  id = "facebook-jssdk"
  ref = d.getElementsByTagName("script")[0]
  return  if d.getElementById(id)
  js = d.createElement("script")
  js.id = id
  js.async = true
  js.src = "//connect.facebook.net/en_US/all.js"
  ref.parentNode.insertBefore js, ref
) document

$ ->
  $('h1.logo').fitText().lettering() # For a prettier logo

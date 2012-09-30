# Add all the app-wide coffeescript here.

# Facebook auth
window.fbAsyncInit = ->
  FB.init
    appId: "367333956679167" # App ID
    channelUrl: "http://localhost:3000/" # Channel File
    status: true # check login status
    cookie: true # enable cookies to allow the server to access the session
    xfbml: true # parse XFBML

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

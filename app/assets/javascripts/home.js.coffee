# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

success = (position) ->
	console.log "me tthree"
	$("#location").text(position.coords.latitude+"asd")
	console.log position.coords.latitude
error =(message)->
    $("#loaction").text("ndfln")


$(document).on 'click', '#clickme', (e) ->  
	console.log "me"
	if navigator.geolocation
		console.log "me too"
		navigator.geolocation.getCurrentPosition(success, error)
	else
		$("#location").text("No supported")


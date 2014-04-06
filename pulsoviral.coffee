define (require) ->
	config = {}
	actions = []
	init = (params) -> 
		params.id ?= 24
		params.size ?= 20
		params.refreshrate ?=5000 #in milliseconds
		config.feedUrl = "//pulsoviral.cloudant.com/pulso_" +
			params.id +
			"/_design/skin/_list/jsonp/txtsbydate_dos?limit=" +
			params.size +
			"&reduce=false&descending=true&callback=?"
		console.log "Pulso is Starting with the following config :", config
		setInterval () ->
			feed()
		,params.refreshrate
	feed = () ->
		console.log "getting data ..!", $
		$.getJSON config.feedUrl, (data) ->
			if data && data.rows && data.rows.length
				if actions.length == data.rows.length #we are full, need to romove the differences
					$.each data.rows , (indice,element) ->
						console.log "here"

	yell = (a) -> "#{ shout a }!!!"

	{init, yell}
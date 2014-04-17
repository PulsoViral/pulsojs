define (require) ->
  config = {}
  actions = []
  cn = {
    clear: () ->
    log: (w) ->
  }
  init = (params) ->
    cn = console if params.debug
    params.id ?= 24
    params.size ?= 20
    params.refreshrate ?=5000 #in milliseconds
    params.baseUrl ?= "http://www.pulsoviral.com/"
    cn.log "\n\n\n\/\*==========  Init  ==========\*\/"
    config.feedUrl = "//pulsoviral.cloudant.com/pulso_" +
      params.id +
      "/_design/skin/_list/jsonp/txtsbydate_dos?limit=" +
      params.size +
      "&reduce=false&descending=true&callback=?"
    config.size = params.size
    config.baseUrl = params.baseUrl
    cn.log "Config \n", JSON.stringify config
    setInterval () ->
      feed()
    ,params.refreshrate
  feed = () ->
    $.getJSON config.feedUrl, (data) ->
      if data && data.rows && data.rows.length
        cn.log actions.length, data.rows.length
        if actions.length == data.rows.length
          #we are full, need to romove the differences
          for index in [0...data.rows] by 1
            el_remove data.rows[index].id if !(el_exists data.rows[index].id)
        for index in [0...data.rows] by 1
          if actions.length > 0
            el_add data.rows[index] if !(el_exists data.rows[index].id)
          else
            el_add data.rows[index]
  ## element operations
  el_exists = (id) ->
    retval = false
    for t in [0...actions.length] by 1
      if actions[t].id == id
        retval = true
        break
    retval
  el_index = (id) ->
    retval = -1
    for t in [0...actions.length] by 1
      if actions[t].id == id
        retval = t
        break
    retval
  el_remove = (id) ->
    actions.splice (el_index id), 1
    cn.log "-" + id
  el_availableslots = () ->
    retval = 0
    if actions.length > 0
      for t in [0...actions.length] by 1
        if actions[t].views == 0
          retval++
    config.size - retval
  el_add = (el) ->
    return if (el_exists el.id) || (el_availableslots < 1)
    switch el.value.pulso_family
      when "twitter"
        if el.value.user?
          el.from_name = el.value.user.screen_name
        else
          el.from_name = el.value.from_user_name
        el.ava_image_sm = el.value.user.profile_image_url
        el.ava_image_lg = (el.ava_image_sm.replace "_normal","")
        el.txt = el.value.text
      when "instagram"
        if el.value.caption
          el.ava_image_sm = el.value.caption.from.profile_picture
          el.ava_image_lg = el.value.caption.from.profile_picture
          el.from_name =  el.value.caption.from.full_name
          el.txt = el.value.caption.text
      when "foursquare"
        if el.value.pulso_avatar?
          el.ava_image_lg = el.value.pulso_avatar
        else
          el.ava_image_lg = config.baseUrl + "/images/generic_avatar.gif"
        el.ava_image_sm = el.ava_image_lg
        if el.value.pulso_username
          el.from_name = el.value.pulso_username
        else
          el.from_name = "A Shy User"
        el.txt = ""
        if el.value.checkin && el.value.checkin.shout
          el.txt = el.value.checkin.shout
  yell = (a) -> "#{ shout a }!!!"

  {init, yell}
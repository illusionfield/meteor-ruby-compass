class @onScreenDiv
  prefix = "compass"
  div: document.createElement "div"
  
  constructor: (templ) ->
    Blaze.render Template["#{prefix}_#{templ}"], @div if typeof Template["#{prefix}_#{templ}"] is "object"
    @div.style.display = "block"
    document.body.appendChild @div

  node: () ->
    $ @div

  kill: () ->
    document.body.removeChild @div

@OnscreenDiv = (tmp) ->
  div = document.createElement "div"
  Blaze.render tmp, div
  div.style.display = "block"
  document.body.appendChild div

  kill: ->
    document.body.removeChild div
  node: ->
    $ div

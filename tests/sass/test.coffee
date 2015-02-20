Tinytest.add "compass - sass", (test) ->
  d = OnscreenDiv Template.sass
  d.node().css "display", "block"
  p = d.node().find ".test-sass"
  test.equal p.css("color"), "rgb(204, 204, 204)"
  do d.kill

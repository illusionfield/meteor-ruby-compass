Tinytest.add "compass - import", (test) ->
  d = OnscreenDiv Template.import
  d.node().css "display", "block"
  i = d.node().find ".example-import"
  test.equal i.css("display"), "inline-block"
  test.equal i.css("color"), "rgb(0, 0, 0)"
  do d.kill

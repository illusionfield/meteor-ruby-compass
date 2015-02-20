Tinytest.add "compass - operators", (test) ->
  d = OnscreenDiv Template.operators
  d.node().css "display", "block"
  i = d.node().find ".complimentary"
  test.equal i.css("float"), "right", "operators fail"
  test.equal i.css("font-size"), "18px", "operators fail"
  do d.kill

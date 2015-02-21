testName = "import"

Tinytest.add "compass - #{testName}", (test) ->
  d = new onScreenDiv "#{testName}"
  d.node().css "display", "block"
  i = d.node().find ".test-#{testName}"
  test.equal i.css("display"), "inline-block"
  test.equal i.css("color"), "rgb(0, 0, 0)"
  do d.kill

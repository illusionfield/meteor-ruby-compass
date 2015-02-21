testName = "variables"

Tinytest.add "compass - #{testName}", (test) ->
  d = new onScreenDiv "#{testName}"
  d.node().css "display", "block"
  p = d.node().find ".test-#{testName}"
  test.equal p.css("color"), "rgb(204, 204, 204)"
  do d.kill

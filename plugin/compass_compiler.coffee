RunCommand = (bin,args,file) ->
  ret = result: "", error: ""
  try
    future = new Future()
    throw bin unless _.isString bin
    throw args unless _.isArray args
    if file 
      throw file unless _.isString file
      args = [file].concat args
    cmd = spawn bin, args
    cmd.stdout.on "data", (data) -> ret.result += data.toString "utf8"
    cmd.stderr.on "data", (data) -> Msg.err data
    cmd.on "error", (err) -> future.throw err
    cmd.on "close", (code) ->
      Msg.warn "Process exited (#{code})" if code
      do future.return
    do future.wait
  catch e
    console.error "#{Msg.banner 'error'} "+e
    ret.error =
      message: "#{Msg.banner 'error'} "+e
      sourcePath: e.filename or file
      line: e.line - 1
      column: e.column + 1
  ret

ImportJsPath = (compileStep) ->
  ###
  return if path.basename(compileStep.inputPath) is "config.rb"
  return Msg.warn "#{compileStep.inputPath} skipped! (#{CompassInit})" if CompassInit
  jspath = RunCommand Envs.Ruby.cmd, ["importpaths"], compileStep.inputPath
  return compileStep.error jspath.error if jspath.error
  contents = JSON.parse do jspath.result.toString
  #console.log contents
  contents
  ###

StylesheetCompiler = (compileStep) ->
  return if path.basename(compileStep.inputPath)[0] is "_"
  return Msg.warn "#{compileStep.inputPath} skipped! (#{CompassInit})" if CompassInit
  css = RunCommand Envs.SASS.cmd, ["--compass", "--sourcemap=inline"], compileStep.inputPath
  return compileStep.error css.error if css.error
  compileStep.addStylesheet
    path: "#{compileStep.inputPath}.css"
    data: css.result
    #sourceMap: JSON.stringify sourceMap if tmpfile

Plugin.registerSourceHandler "rb", {archMatching: 'os'}, ImportJsPath
#Plugin.registerSourceHandler "json", (compileStep) ->
Plugin.registerSourceHandler "scss", {archMatching: 'web'}, StylesheetCompiler
Plugin.registerSourceHandler "sass", {archMatching: 'web'}, StylesheetCompiler

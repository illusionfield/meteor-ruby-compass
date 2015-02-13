debug = true

RunCommand = (bin,args,file) ->
  ret = result: "", error: ""
  try
    future = new Future()
    throw bin unless _.isString bin
    throw args unless _.isArray args 
    args = [file].concat args if file
    cmd = spawn bin, args
    cmd.stdout.on "data", (data) ->
      ret.result += data.toString "utf8"
    cmd.stderr.on "data", (data) ->
      Msg.err data
    cmd.on "error", (err) ->
      future.throw err
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

StylesheetCompiler = (compileStep) ->
  return if path.basename(compileStep.inputPath)[0] is "_"
  return Msg.warn "#{compileStep.inputPath} skipped! (#{CompassInit})" if CompassInit
  {error,result} = RunCommand Envs.SASS.cmd, ["--compass", "--sourcemap=inline", (if debug then "--trace")], compileStep.inputPath
  return compileStep.error error if error
  compileStep.addStylesheet
    path: "#{compileStep.inputPath}.css"
    data: result

Plugin.registerSourceHandler "rb", null
Plugin.registerSourceHandler "config.rb", {archMatching: 'web'}, -> #
Plugin.registerSourceHandler "compass.rb", {archMatching: 'web'}, -> #

Plugin.registerSourceHandler "scss", {archMatching: 'web'}, StylesheetCompiler
Plugin.registerSourceHandler "sass", {archMatching: 'web'}, StylesheetCompiler

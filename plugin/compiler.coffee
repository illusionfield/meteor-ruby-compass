{debug,compile_args,envs,failure} = Config

do CheckEnv

devscript = (compileStep) ->
  #console.log compileStep
  #compileStep.addAsset
  #  path: compileStep.inputPath
  #  data: fs.readFileSync compileStep.fullInputPath

StylesheetCompiler = (compileStep) ->
  devscript compileStep if debug
  return if compileStep.pathForSourceMap[0] is "_" #path.basename(compileStep.inputPath)[0]
  return console.warn "#{PreMsg 'warn'} #{compileStep.inputPath} skipped! (#{failure})" if failure

  try
    {cmd} = envs.SASS
    args = [].concat compile_args.prod
    args = args.concat compile_args.devel if debug
    args.push compileStep.fullInputPath

    {stdout,stderr,code,error,msgtype} = do exec(cmd,args).wait
    #throw new Error "Process exited (#{code})" if code

    compileStep.addStylesheet
      path: "#{compileStep.inputPath}.css"
      data: stdout

  catch e
    compileStep.error
      message: "#{PreMsg msgtype} #{cmd}: #{if debug then e.stack else e}"
      sourcePath: e.filename or compileStep.fullInputPath
      line: e.line - 1
      column: e.column + 1


Plugin.registerSourceHandler "rb", null
Plugin.registerSourceHandler "config.rb", {archMatching: 'web'}, -> #
Plugin.registerSourceHandler "compass.rb", {archMatching: 'web'}, -> #

Plugin.registerSourceHandler "scss", {archMatching: 'web'}, StylesheetCompiler
Plugin.registerSourceHandler "sass", {archMatching: 'web'}, StylesheetCompiler

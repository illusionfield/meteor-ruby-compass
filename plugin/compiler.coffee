do CheckEnv
{debug,compile_args,envs,failure} = Config

RunDev = (compileStep) ->
  #console.log compileStep
  #compileStep.addAsset
  #  path: compileStep.inputPath
  #  data: fs.readFileSync compileStep.fullInputPath

StylesheetCompiler = (compileStep) ->
  RunDev compileStep if debug
  return if compileStep.pathForSourceMap[0] is "_"
  if failure
    failure_warn="#{failure}".warn
    return console.warn "#{PreMsg 'warn'}#{compileStep.inputPath.underline.debug} in #{compileStep.arch.underline} skipped! #{failure_warn}"

  try
    {cmd} = envs.SASS
    args = [].concat compile_args.prod
    args = args.concat compile_args.devel if debug
    args.push compileStep.fullInputPath

    {stdout,stderr,code,error} = do exec(cmd,args).wait
    throw new Error "#{cmd}: (exit #{code}): #{error}" if code or error
    throw new Error stderr if stderr

    compileStep.addStylesheet
      path: "#{compileStep.inputPath}.css"
      data: stdout

  catch e
    compileStep.error
      message: "#{PreMsg 'error'} #{cmd}: #{if debug then e.stack else e}"
      sourcePath: e.filename or compileStep.fullInputPath
      line: e.line - 1
      column: e.column + 1


Plugin.registerSourceHandler "rb", null
Plugin.registerSourceHandler "config.rb", {archMatching: 'web'}, -> #
Plugin.registerSourceHandler "compass.rb", {archMatching: 'web'}, -> #

Plugin.registerSourceHandler "scss", {archMatching: 'web'}, StylesheetCompiler
Plugin.registerSourceHandler "sass", {archMatching: 'web'}, StylesheetCompiler

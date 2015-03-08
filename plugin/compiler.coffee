path          = Npm.require "path"
fs            = Npm.require "fs"
_             = Npm.require "lodash"

{debug,enviroment,compile_args,envs} = Config
checkedEnv = do CheckEnv

StylesheetCompiler = (compileStep) ->
  return if debug is "init"
  RunDev compileStep if debug

  if compileStep.pathForSourceMap[0] is "_"
    console.log "#{PreMsg} #{compileStep.inputPath.underline.debug} in #{compileStep.arch.underline} skipped!\n\t" if debug
    return

  if checkedEnv.error
    console.warn "#{PreMsg 'warn'} #{compileStep.inputPath.underline.debug} in #{compileStep.arch.underline} skipped!\n\t#{checkedEnv.error}" if debug
    return

  try
    {cmd} = envs.SASS
    args = [].concat compile_args.production
    args = args.concat compile_args.development if enviroment is "development"
    args = args.concat compile_args.debug if debug
    args.push compileStep.fullInputPath

    {stdout,stderr,code,error} = do exec(cmd,args).wait
    throw new Error "#{cmd}: (exit #{code}): #{error}" if code or error
    console.warn "#{PreMsg 'warn'} #{cmd}: #{stderr}" if stderr
    return console.warn "#{PreMsg 'warn'} #{cmd}: #{compileStep.inputPath.underline.debug} in #{compileStep.arch.underline} empty, ignored!" unless stdout
    #throw new Error stderr if stderr

    compileStep.addStylesheet
      path: "#{compileStep.inputPath}.css"
      data: stdout

  catch e
    compileStep.error
      message: "#{PreMsg 'error'} #{cmd}: #{e.message}\n
                #{PreMsg 'error'} #{if debug then e.stack else e}"
      sourcePath: e.filename or compileStep.fullInputPath
      line: e.line
      column: e.column + 1


Plugin.registerSourceHandler "rb", null
Plugin.registerSourceHandler "config.rb", {archMatching: 'web'}, -> #
Plugin.registerSourceHandler "compass.rb", {archMatching: 'web'}, -> #

Plugin.registerSourceHandler "scss", {archMatching: 'web'}, StylesheetCompiler
Plugin.registerSourceHandler "sass", {archMatching: 'web'}, StylesheetCompiler

RunDev = (compileStep, options) ->
  options = options or {}
  console.log "-- Debug #{compileStep.inputPath} --"
  #console.log compileStep
  #compileStep.addAsset
  #  path: compileStep.inputPath
  #  data: fs.readFileSync compileStep.fullInputPath

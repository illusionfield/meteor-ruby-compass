path          = Npm.require "path"
fs            = Npm.require "fs"
{spawn}       = Npm.require "child_process"
{gzip,gunzip} = Npm.require "zlib"
Future        = Npm.require "fibers/future"
_             = Npm.require "lodash"
Colors        = Npm.require "colors"

Colors.setTheme
  verbose:  "cyan"
  info:     "green"
  warn:     "yellow"
  debug:    "blue"
  error:    "red"

{debug,files,envs,unacceptable} = Config

@PreMsg = (msgtype) ->
  msgtype = msgtype or 'info'
  " #{'=>'.green} [#{'RubySASS'.underline.cyan} #{Colors[msgtype] msgtype}]:"

ArchiveUtility =
  uncompress: (archive,encoding) ->
    ret = new Future
    gunzip (new Buffer archive,encoding or ""), (error,buf) ->
      ret.return
        error: error
        result: buf?.toString? "utf8"
    ret

  compress: (str,encoding) ->
    ret = new Future
    gzip (if typeof str is "string" then str else new Buffer str), (error,buf) ->
      ret.return
        error: error
        result: buf?.toString? encoding or ""
    ret

@exec = (cmd,args,options) ->
  #console.error "#{PreMsg 'error'} Command error: #{cmd}" unless _.isString cmd
  #console.error "#{PreMsg 'error'} Arguments error: #{args}" unless _.isArray args
  options = options or {}
  stream = stdout: "", stderr: "", code: 0, error: ""
  ret = new Future
  process = spawn cmd, args, options
  process.stdout.setEncoding 'utf8'
  process.stderr.setEncoding 'utf8'

  process.stdout.on "data", (data) ->
    stream.stdout += data

  process.stderr.on "data", (data) ->
    stream.stderr += data

  process.on "error", (err) ->
    stream.error += err

  process.on "close", (code) ->
    ret.return stream

  ret.process = process
  ret

@CheckEnv = () ->
  do RunDev if debug

  ret = result: "", error: ""
  if process.argv[2] in unacceptable
    ret.warning = "#{process.argv[2]} request: Temporarily not available in this package features ...".warn
    console.warn "#{PreMsg 'warn'} #{ret.warning}"
    return ret

  try
    do _(files).forEach ({name,content}) ->
      return if fs.existsSync (confPath = "#{do process.cwd}/#{name}")
      {error,result} = do ArchiveUtility.uncompress(content,"base64").wait
      throw new Error "Cannot create #{name.underline.debug} on project root: #{error}" if error
      console.info "#{do PreMsg} #{name} not exists, creating on project root!"
      fs.writeFileSync confPath, result
    .value
    
    do _(envs).forEach ({cmd,spec,test,init}, name) ->
      test_args = [].concat test or '-v'
      {stdout,stderr,code,error} = do exec(cmd,test_args).wait
      if error or code
        throw new Error "#{name} not available (exit #{code}): #{error}" if spec is "required"
        return console.warn "#{PreMsg 'warn'} #{name} not available (exit #{code}): #{error}"
      return console.info "#{do PreMsg} #{name}: #{'OK'.green}" if spec isnt "required" or not init
      
      init_args = [].concat init
      {stdout,stderr,code,error} = do exec(cmd,init_args).wait
      throw new Error "#{name} #{init_args} (exit #{code}): #{error}" if error or code
      #throw new Error stderr if stderr
      return console.warn "#{PreMsg 'warn'} #{name}: #{stderr}" if stderr
      if stdout
        console.info "#{do PreMsg} #{name} #{init_args}:"
        console.info stdout
      console.info "#{do PreMsg} #{name}: #{'OK'.green}"
    .value

  catch e
    console.error "#{PreMsg 'error'}#{e} #{"--[ Package DISABLED! ]--".error}".replace "\n", " "
    ret.error = "#{e}".yellow
  
  finally
    return ret

RunDev = (options) ->
  options = options or {}
  console.info "-- Init debug --".blue


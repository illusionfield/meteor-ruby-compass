path          = Npm.require "path"
@fs           = Npm.require "fs"
{spawn}       = Npm.require "child_process"
{gzip,gunzip} = Npm.require "zlib"
Future        = Npm.require "fibers/future"
Colors        = Npm.require "colors"

{files,envs,unacceptable} = Config

Colors.setTheme
  verbose:  "cyan"
  info:     "green"
  warn:     "yellow"
  debug:    "blue"
  error:    "red"

@PreMsg = (msgtype) ->
  msgtype = msgtype || 'info'
  " #{'=>'.bold} [#{'RubySASS'.verbose.underline} #{(msgtype)[msgtype]}]: "


# !!!!!!!!!!!!!!!!!!!!!!!!!!! Deprecated !!!!!!!!!!!!!!!!!!!!!!!!!!! #
@Msg =
  banner: (msgtype,message) ->
    " #{'=>'.bold} [#{'RubySASS'.verbose.underline} #{(msgtype)[msgtype]}]: "
  message: (msg) ->
    if msg.message then msg.message else do msg.toString
  info: (msg) ->
    console.log do "#{@banner 'info'} #{@message msg}".trim
  warn: (msg) ->
    console.warn do "#{@banner 'warning'} #{@message msg}".trim
  err: (msg) ->
    console.error do "#{@banner 'error'} #{@message msg}".trim
# !!!!!!!!!!!!!!!!!!!!!!!!!!! !!!!!!!!!!! !!!!!!!!!!!!!!!!!!!!!!!!!!! #


ArchiveUtility =
  uncompress: (archive,encoding) ->
    future = new Future()
    ret = ""
    try
      gunzip (new Buffer archive,encoding or ""), (error,buf) ->
        return future.throw error if error isnt null
        ret = buf?.toString? "utf8" 
        do future.return
      do future.wait
    catch e
      Msg.err e
      return false
    ret
  
  compress: (str,encoding) ->
    future = new Future()
    ret = ""
    try
      gzip (if typeof str is "string" then str else new Buffer str), (error,buf) ->
        return future.throw error if error isnt null
        ret = buf?.toString? encoding or ""
        do future.return
      do future.wait
    catch e
      Msg.err e
      return false
    ret


@exec = (cmd,args,file) ->
  return Msg.err "Command error: #{cmd}" unless _.isString cmd
  return Msg.err "Arguments error: #{args}" unless _.isArray args

  stream = stdout: "", stderr: "", code: 0, err: ""
  ret = new Future
  options = options or {}
  process = spawn cmd, args, options
  process.stdout.setEncoding 'utf8'
  process.stderr.setEncoding 'utf8'

  process.stdout.on "data", ((data) ->
    stream.stdout += data
    #return stream
  ), (err) ->
    stream.err += "stdout: "+err
    #return stream

  process.stderr.on "data", ((data) ->
    stream.stderr += data
    #return stream
  ), (err) ->
    stream.err += "stderr: "+err
    #return stream

  process.on "close", (code) ->
    stream.msgtype = 'warn' if stream.code=code > 0
    stream.msgtype = 'error' if stream.code=code < 0
    ret.return stream
    #return ret.return stream
  ret.process = process
  ret
  #message: "#{Msg.banner if processCode is -1 then 'error' else 'warning'} #{bin}: #{if compassDebug then e.stack else e}"
  #sourcePath: e.filename or file
  #line: e.line - 1
  #column: e.column + 1

###
exec = (cmd,args) ->
  child = spawn cmd,args
  ret = undefined
  future = new Future()
  child.stdout.on "data", (data) ->
    ret = data
  child.stderr.on "data", (err) ->
    future.throw "#{cmd}: #{err}"
  child.on "error", (err) ->
    future.throw "#{cmd}: #{err}"
  child.on "close", (code) ->
    return (if code > 0 then Msg.warn "Process exited (#{code})") if code
    do future.return
  do future.wait
  do ret.toString
###

CheckEnv = () ->
  ret = false
  _(files).forEach ({name,content}) ->
    return if fs.existsSync (confPath = "#{do process.cwd}/#{name}")
    Msg.info "#{name} not exists, creating on project root!"
    fs.writeFileSync confPath, ArchiveUtility.uncompress content,"base64"
  _(envs).forEach ({cmd,spec}, name) ->
    try
      #envs[name].version = exec cmd,["-v"]
      v = exec cmd,["-v"]
      Msg.info "#{name} (#{v}): #{'OK'.green}"    
    catch e
      return Msg.err e if spec isnt "required"
      ret = e 
  ret

Init = () ->
  #try
  return Msg.warn "#{arg} request: Temporarily not available in this package features ..." if (arg=process.argv[2]) in unacceptable
  if (err=do CheckEnv)
    Msg.err "#{err} --[ Package DISABLED! ]--"
    throw err 
  #catch e
  #  throw err
  #  return "Init failed"
  #return false

@CompassInit = do Init
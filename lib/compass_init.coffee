@fs = Npm.require "fs"
@path = Npm.require "path"
{@spawn} = Npm.require "child_process"
{gzip,gunzip} = Npm.require "zlib"
@Future = Npm.require "fibers/future"
Colors = Npm.require "colors"
#@spawn = spawn

@Envs =
  Ruby:
    cmd: "ruby"
    spec: "required"
  Bundle:
    cmd: "bundle"
    spec: "required"
  SASS:
    cmd: "sass"
    spec: "required"
  Compass:
    cmd: "compass"
    spec: "required"

UnAcceptable = [ "publish" ]

Colors.setTheme
  verbose: "cyan"
  info: "green"
  warning: "yellow"
  debug: "blue"
  error: "red"

@Msg =
  banner: (typ) ->
    " #{'=>'.bold} [#{'RubySASS'.verbose.underline} #{(typ)[typ]}]:"
  message: (msg) ->
    if msg.message then msg.message else do msg.toString
  info: (msg) ->
    console.log do "#{@banner 'info'} #{@message msg}".trim
  warn: (msg) ->
    console.warn do "#{@banner 'warning'} #{@message msg}".trim
  err: (msg) ->
    console.error do "#{@banner 'error'} #{@message msg}".trim

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

RunCommand = (cmd,args) ->
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

CheckEnv = () ->
  ret = false
  _(ConfigFiles).forEach ({name,content}) ->
    return if fs.existsSync (confPath = "#{do process.cwd}/#{name}")
    Msg.info "#{name} not exists, creating on project root!"
    fs.writeFileSync confPath, ArchiveUtility.uncompress content,"base64"
  _(Envs).forEach ({cmd,spec}, name) ->
    try
      Envs[name].version = RunCommand cmd,["-v"]
      Msg.info "#{name} #{'OK'.green}"    
    catch e
      return Msg.err e if spec isnt "required"
      ret = e 
  ret

Init = () ->
  try
    return Msg.warn "Temporarily disabled feature...: #{arg}" if (arg=process.argv[2]) in UnAcceptable
    throw err if (err=do CheckEnv)
  catch e
    Msg.err "#{e} --[ Package DISABLED! ]--"
    return "Init failed"
  return false

@CompassInit = do Init
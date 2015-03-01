path          = Npm.require "path"
@fs           = Npm.require "fs"
{spawn}       = Npm.require "child_process"
{gzip,gunzip} = Npm.require "zlib"
Future        = Npm.require "fibers/future"
Colors        = Npm.require "colors"

{files,envs,unacceptable,failure,compile_args} = Config

Colors.setTheme
  verbose:  "cyan"
  info:     "green"
  warn:     "yellow"
  debug:    "blue"
  error:    "red"

@PreMsg = (msgtype) ->
  msgtype = msgtype || 'info'
  " #{'=>'.bold} [#{'RubySASS'.verbose.underline} #{(msgtype)[msgtype]}]: "

ArchiveUtility =
  uncompress: (archive,encoding) ->
    future = new Future
    ret = ""
    try
      gunzip (new Buffer archive,encoding or ""), (error,buf) ->
        return future.throw error if error isnt null
        ret = buf?.toString? "utf8" 
        do future.return
      do future.wait
    catch e
      console.error "#{PreMsg 'error'} #{e}"
      return false
    ret
  
  compress: (str,encoding) ->
    future = new Future
    ret = ""
    try
      gzip (if typeof str is "string" then str else new Buffer str), (error,buf) ->
        return future.throw error if error isnt null
        ret = buf?.toString? encoding or ""
        do future.return
      do future.wait
    catch e
      console.error "#{PreMsg 'error'} #{e}"
      return false
    ret


@exec = (cmd,args,options) ->
  console.error "#{PreMsg 'error'} Command error: #{cmd}" unless _.isString cmd
  console.error "#{PreMsg 'error'} Arguments error: #{args}" unless _.isArray args

  options = options or {}
  stream = stdout: "", stderr: "", code: 0, err: ""
  ret = new Future
  process = spawn cmd, args, options
  process.stdout.setEncoding 'utf8'
  process.stderr.setEncoding 'utf8'

  process.stdout.on "data", ((data) ->
    stream.stdout += data
  ), (err) ->
    stream.err += "stdout: #{err}"

  process.stderr.on "data", ((data) ->
    stream.stderr += data
  ), (err) ->
    stream.err += "stderr: #{err}"
  
  process.on "error", (err) ->
    stream.err += err

  process.on "close", (code) ->
    stream.msgtype = 'warn' if stream.code=code > 0
    stream.msgtype = 'error' if stream.code=code < 0
    ret.return stream
  ret.process = process
  ret

@CheckEnv = () ->
  return console.warn "#{PreMsg 'warn'} #{arg} request: Temporarily not available in this package features ..." if (arg=process.argv[2]) in unacceptable
  try
    _(files).forEach ({name,content}) ->
      return if fs.existsSync (confPath = "#{do process.cwd}/#{name}")
      console.info "#{do PreMsg} #{name} not exists, creating on project root!"
      fs.writeFileSync confPath, ArchiveUtility.uncompress content,"base64"
    _(envs).forEach ({cmd,spec}, name) ->
      args = [].concat compile_args.test
      {stdout,stderr,code,err,msgtype} = do exec(cmd,args).wait
      return console.info "#{do PreMsg} #{name}: #{'OK'.green}" unless code
      return console.warn "#{PreMsg 'warn'} #{name}: Process exited (#{code})" if spec isnt "requiured"
      throw new Error "Process exited #{name} (#{code}): #{err}"
  catch e
    console.error "#{PreMsg 'error'} #{e} --[ Package DISABLED! ]--"
    failure = e


###
console.log cmd,args

#throw new Error "#{error} --[ Package DISABLED! ]--"

v = exec cmd,args

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


Init = () ->
   if (err=do CheckEnv)

failure = do Init

#if (err=do CheckEnv)
  #console.error "#{err} --[ Package DISABLED! ]--"
  #throw err 
###
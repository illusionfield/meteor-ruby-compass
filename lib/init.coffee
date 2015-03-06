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
    ret = new Future
    gunzip (new Buffer archive,encoding or ""), (error,buf) ->
      ret.return
        error: error
        result: buf?.toString? "utf8"
    ret

    #stream = error: "", result: ""
    #future = new Future
    #ret = ""
    #try
      #stream.result = buf?.toString? "utf8"
      #ret.return stream
      #return future.throw error if error isnt null
      #ret = buf?.toString? "utf8" 
      #do future.return
    #do ret.wait
    #catch e
    #  console.error "#{PreMsg 'error'} #{e}"
    #  return false
    #ret
  
  compress: (str,encoding) ->
    ret = new Future
    gzip (if typeof str is "string" then str else new Buffer str), (error,buf) ->
      ret.return
        error: error
        result: buf?.toString? encoding or ""
    ret

    ###
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
    ###


@exec = (cmd,args,options) ->
  console.error "#{PreMsg 'error'} Command error: #{cmd}" unless _.isString cmd
  console.error "#{PreMsg 'error'} Arguments error: #{args}" unless _.isArray args

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
    #stream.msgtype = 'warn' if stream.code=code > 0
    #stream.msgtype = 'error' if stream.code=code < 0
    ret.return stream
  ret.process = process
  ret

@CheckEnv = () ->
  return console.warn "#{PreMsg 'warn'} #{arg} request: Temporarily not available in this package features ..." if (arg=process.argv[2]) in unacceptable
  try
    _(files).forEach ({name,content}) ->
      #return if fs.existsSync (confPath = "#{do process.cwd}/#{name}")
      confPath = "#{do process.cwd}/#{name}"
      {error,result} = do ArchiveUtility.uncompress(content,"base64").wait
      throw new Error "Cannot create #{name.underline.debug} on project root: #{error}" if error
      console.info "#{do PreMsg} #{name} not exists, creating on project root!"
      fs.writeFileSync confPath, result
    _(envs).forEach ({cmd,spec}, name) ->
      args = [].concat compile_args.test
      {stdout,stderr,code,error} = do exec(cmd,args).wait
      if error or code
        throw new Error "#{name} not available (#{code}): #{error}" if spec is "required"
        return console.warn "#{PreMsg 'warn'} #{name} not available (#{code}): #{error}"
      return console.info "#{do PreMsg} #{name}: #{'OK'.green}"
  catch e
    console.error "#{PreMsg 'error'} #{e} --[ Package DISABLED! ]--"
    failure = e

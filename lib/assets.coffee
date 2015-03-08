@Config =

  # enviroment = development or production
  enviroment: "development"

  # debug = false or true or "init"
  debug: true

  unacceptable: [
    "publish"
  ]

  files: [
    name: "config.rb"
    content: "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"
  ,
    name: "Gemfile"
    content: "H4sIAAAAAAAAAzXJMQqAMAxA0T2nCHETavfeRm2oIpqSpIO31wpu//MGDGNAbcvdA0yaroy0uVdLMXYofNokWgjgTaRVzjqb9VVpFZOzOWYBxM91Ppj+6RbatTsBXxkezemgl28AAAA="
  ,
    name: "Rakefile"
    content: "H4sIAAAAAAAAAz1OSwrCMBDd5xSPilTBeoBCdenaI6Rm1NA00UwCStu7O1XqYph5v+FFemYbCWXM7ftGPZfI3hEzDF2tJ3PEiXoolTR3qIXU2SU0B9ScdEyL8AUwQQF8x/o8tNkbR7BeFOdQVbK90S54EnBxpP0kfoyh2yESj5IEHjkxiqu2Din8w3MvbOROmdFgNYh/Ty+bftS0LZbSoZM35I2a5wP6HJ0l3AAAAA=="
  ]

  envs:
    Ruby:
      cmd: "ruby"
      spec: "required"
      test: "-v"
    Bundler:
      cmd: "bundle"
      spec: "required"
      test: "-v"
      init: "install"
    SASS:
      cmd: "sass"
      spec: "required"
      test: "-v"
    Compass:
      cmd: "compass"
      spec: "required"
      test: "-v"

  compile_args:
    production: [
      "--compass"
    ]
    development: [
      "--sourcemap=inline"
      "--trace"
    ]
    debug: [
      "-C"
      "-g"
      "-l"
    ]

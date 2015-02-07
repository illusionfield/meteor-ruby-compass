# Compass is an open-source CSS authoring framework which uses the Sass stylesheet language to make writing stylesheets powerful and easy.

## Install

Package required `sass` gem.

    $ gem install sass
    # or check http://sass-lang.com/install

### Add package

    $ meteor add illusionfield:ruby-sass


## Configuration

### Common Options
  // Specify a Sass import path.
  "load-path": [],

  // Require a Ruby library before running Sass.
  "require": [],

  // Make Compass imports available and load project configuration. Uncomment:
  "compass": true,

  // Output style. Can be nested (default), compact, compressed, or expanded. Uncomment:
  "style": "expanded",

### Input & Output
  // To use the CSS-superset SCSS syntax. Uncomment:
  "scss": true,

  /* How to link generated output to the source files. Uncomment:
      auto (default): relative paths where possible, file URIs elsewhere
      file: always absolute file URIs
      inline: include the source text in the sourcemap
      none: no sourcemaps */
  "sourcemap": "none",

  // Specify the default encoding for input files.
  "default-encoding": "UTF-8",

  // Not use Unix-style newlines in written files. -! Always true on Unix. !-
  //"unix-newlines": true,

  // To emit output that can be used by the FireSass Firebug plugin. Uncomment:
  "debug-info": true,

  // to emit comments in the generated CSS indicating the corresponding source line. Uncomment:
  //"line-comments": true,

### Miscellaneous
  // The path to save parsed Sass files. Default: ".sass-cache".
  "cache-location": ".sass-cache",

  // To don't cache parsed Sass files. Uncomment:
  //"no-cache": true,

  // To show a full Ruby stack trace on error. Uncomment:
  "trace": true,

  // How many digits of precision to use when outputting decimal numbers. Default: 5.
  "precision": 5


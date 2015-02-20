'use strict';

Package.describe({
  summary: 'Ruby Compass integration',
  git: 'https://github.com/illusionfield/meteor-ruby-compass.git',
  name: 'illusionfield:ruby-compass',
  version: '0.0.3',
  documentation: 'README.md'
});

// Npm.depends({});

Package.onUse(function(api) {
  api.versionsFrom('1.0.3');
  api.use(['coffeescript']);
});

Package.registerBuildPlugin({
  name: 'StylesheetCompiler',
  use:  [ 'coffeescript@1.0.5', 'underscore@1.0.2' ],
  sources: [ 'lib/assets.coffee', 'lib/compass_init.coffee', 'plugin/compass_compiler.coffee' ],
  npmDependencies: { 'colors': '1.0.3' }
});

Package.onTest(function(api) {
  api.use(['test-helpers', 'tinytest', 'coffeescript', 'jquery', 'templating', 'blaze', 'ui']);
  api.use('illusionfield:ruby-compass');

  api.add_files([
    'tests/oscreenDiv.coffee',

    'tests/operators/template.html',
    'tests/operators/style.sass',
    'tests/operators/test.coffee',

    'tests/import/template.html',
    'tests/import/style.sass',
    'tests/import/test.coffee',

    'tests/sass/template.html',
    'tests/sass/style.sass',
    'tests/sass/test.coffee'

  ], 'client');
});

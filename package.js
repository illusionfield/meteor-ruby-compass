'use strict';

Package.describe({
  summary: 'Ruby Compass integration',
  git: 'https://github.com/illusionfield/meteor-ruby-compass.git',
  name: 'illusionfield:ruby-compass',
  version: '0.0.3',
  documentation: 'README.md'
});

Npm.depends({
  'jquery': '2.1.3'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0.3');
  api.use(['coffeescript']);
});

Package.registerBuildPlugin({
  name: 'StylesheetCompiler',
  use:  [ 'coffeescript', 'underscore' ],
  sources: [ 'lib/assets.coffee', 'lib/init.coffee', 'plugin/compiler.coffee' ],
  npmDependencies: { 'colors': '1.0.3' }
});

Package.onTest(function(api) {
  api.use(['tinytest', 'coffeescript', 'templating', 'blaze']);
  api.use('illusionfield:ruby-compass');

  api.add_files([
    '.npm/package/node_modules/jquery/dist/jquery.js',
    'lib/tests.coffee',
    'tests/templates.html',

    'tests/operators/style.sass',
    'tests/operators/test.coffee',

    'tests/import/style.sass',
    'tests/import/test.coffee',

    'tests/variables/style.sass',
    'tests/variables/test.coffee'

  ], 'client');
});

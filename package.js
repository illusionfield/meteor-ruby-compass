Package.describe({
  summary: 'Compass is an open-source CSS authoring framework which uses the Sass stylesheet language to make writing stylesheets powerful and easy.',
  git: "https://github.com/illusionfield/meteor-ruby-compass.git",
  name: "illusionfield:ruby-compass",
  version: "0.0.1",
  documentation: 'README.md'
});

Package.onUse(function(api) {
   api.versionsFrom('1.0.3');
});

Package.registerBuildPlugin({
  name: 'StylesheetCompiler',
  use:  [ 'coffeescript@1.0.5', 'underscore@1.0.2' ],
  sources: [ 'lib/assets.coffee', 'lib/compass_init.coffee', 'plugin/compass_compiler.coffee' ], //'lib/init.rb',
  npmDependencies: { 'colors': '1.0.3' }
});

Package.onTest(function(api) {
  api.use(['test-helpers', 'tinytest', 'jquery', 'templating', 'blaze', 'ui']);
  api.use('illusionfield:ruby-compass');

  api.add_files([
    'tests/oscreenDiv.js',
    'tests/presence/template.html',
    'tests/presence/style.scss',
    'tests/presence/test.js',

    'tests/extend/template.html',
    'tests/extend/style.scss',
    'tests/extend/test.js',

    'tests/operators/template.html',
    'tests/operators/style.scss',
    'tests/operators/test.js',

    'tests/functions/template.html',
    'tests/functions/style.scss',
    'tests/functions/test.js',

    'tests/mixin/template.html',
    'tests/mixin/style.scss',
    'tests/mixin/test.js',

    'tests/import/template.html',
    'tests/import/style.scss',
    'tests/import/test.js',

    'tests/sass/template.html',
    'tests/sass/style.sass',
    'tests/sass/test.js'

  ], 'client');
});

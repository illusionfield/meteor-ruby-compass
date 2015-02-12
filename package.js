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
  api.use('tinytest');
  api.use('illusionfield:ruby-compass');
  api.addFiles('tests/tests.js');
});

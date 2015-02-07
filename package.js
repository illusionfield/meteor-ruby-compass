Package.describe({
  summary: 'Compass is an open-source CSS authoring framework which uses the Sass stylesheet language to make writing stylesheets powerful and easy.',
  git: "https://github.com/illusionfield/meteor-ruby-compass.git",
  name: "illusionfield:ruby-compass",
  version: "0.0.1",
  documentation: 'README.md'
});

/*
var pkg,p,_err=false
var path = Npm.require("path");
var fs = Npm.require("fs");
Npm.depends({'colors': '1.0.3'});

var __indexOf = Array.prototype.indexOf || function(item) {
  for (var i = 0, l = this.length; i < l; i++) {
    if (this[i] === item) return i;
  }
  return -1;
};

try {
  var extlibsJsonFile = path.resolve('./extlibs.json');
  var fileContent = fs.readFileSync(extlibsJsonFile);
  var packages = JSON.parse(fileContent.toString());
  for (p in packages) {
    pkg = packages[p];
    if ((__indexOf.call(pkg.add, "client") && __indexOf.call(pkg.add, "server")) < 0) throw pkg.add
    if (!pkg.addFiles.length) throw pkg.addFiles
    for (file in pkg.addFiles) pkg.addFiles[file] = path.resolve(pkg.addFiles[file]);
  }
} catch(ex) {
  console.error('ERROR: extlibs.json [ ' + ex.message + ' ]');
  _err = true
}

Package.onUse(function(api) {
  api.versionsFrom('1.0.3');
  if (_err) return
  for (p in packages) {
    pkg = packages[p];
    if (pkg.use) api.use(pkg.use, pkg.add);
    //if (pkg.imply) api.imply(':@', pkg.add);
    if (pkg.addFiles) api.addFiles(pkg.addFiles, pkg.add)
    if (pkg.export) api.export(pkg.export, pkg.add)
  }
});
*/

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

/*
var packagesJsonFile = path.resolve('./packages.json');
try {
  var fileContent = fs.readFileSync(packagesJsonFile);
  Npm.depends(packages);
  var packages = JSON.parse(fileContent.toString());
} catch(ex) {
  console.error('ERROR: packages.json parsing error [ ' + ex.message + ' ]');
}
*/
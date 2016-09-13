#!/usr/bin/env node
'use strict';

var fs = require('fs');

var getValue = function(config, name) {
    var value = config.match(new RegExp('<' + name + '>(.*?)</' + name + '>', "i"))
    if(value && value[1]) {
        return value[1]
    } else {
        return null
    }
}

function fileExists(path) {
  try  {
    return fs.statSync(path).isFile();
  }
  catch (e) {
    return false;
  }
}

function directoryExists(path) {
  try  {
    return fs.statSync(path).isDirectory();
  }
  catch (e) {
    return false;
  }
}

var config = fs.readFileSync("config.xml").toString()
var name = getValue(config, "name")

if (directoryExists("platforms/ios")) {
  var paths = ["LineAdapter.plist", "platforms/ios/www/LineAdapter.plist"];

  for (var i = 0; i < paths.length; i++) {
    if (fileExists(paths[i])) {
      try {
        var contents = fs.readFileSync(paths[i]).toString();
        // fs.writeFileSync("platforms/ios/" + name + "/Resources/LineAdapter.plist", contents)
      } catch(err) {
        process.stdout.write(err);
      }

      break;
    }
  }
}


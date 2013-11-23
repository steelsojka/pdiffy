var clc = require("cli-color");
var _ = require("lodash");
var capture = require("./capture");
var fs = require("fs");

module.exports.combine = function(sessionPaths, output) {
  var error = null;

  var sessions = sessionPaths.map(function(session) {
    if (!fs.existsSync(session)) {
      error = "Session file does not exist! - " + session;
      return;
    }

    return JSON.parse(fs.readFileSync(session), 'utf8');
  });

  if (error !== null) {
    throw new Error(error);
  }

  console.log(clc.green.underline("\nCombining sessions:"));

  sessionPaths.forEach(function(path) {
    console.log("- " + path);
  });

  var newSession = {
    shots: _(sessions).pluck("shots").flatten().value()
  };

  capture.writeSession({
    output: output 
  }, newSession);
  
};

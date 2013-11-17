var _ = require("lodash");
var webshot = require("webshot");
var async = require("async");
var fs = require("fs");
var clc = require("cli-color");
var noop = function() {};
var globalOptions;

var capture = function(config, callback) {
  globalOptions = config.options || {}; 
  var timestamp = config.schedule && config.timestamp !== false;
  var output = config.output;

  // Add a timestamp for scheduled tasks unless timestamp is false in config
  if (timestamp) {
    output = output.replace(".pdiffy", "." + Date.now() + ".pdiffy");
  }
  
  async.map(config.captures, processCapture, function(err, results) {
    var session = {shots: results};

    fs.writeFile(output, JSON.stringify(session), function(err) {
      if (err) throw err;
      console.log(clc.blue("Session written to ") + clc.cyan(output));
      (callback || noop)();
    });
  });
};

var processCapture = function(capture, callback) {
  var results = {}; 
  var options = _.extend(globalOptions, (capture.options || {}));
  var imageData = "";

  console.log(clc.blue("Capturing: ") + capture.url);

  webshot(capture.url, options, function(err, stream) {
    stream.on('data', function(data) {
      imageData += data.toString('base64');
    });

    stream.on('end', function() {

      console.log(clc.bgGreen.black("Done") + " " + capture.url);

      callback(null, {
        path: "data:image/png;base64," + imageData,
        displayURL: capture.url
      });
    });
  });

};


module.exports.capture = capture;

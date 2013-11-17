var _ = require("lodash");
var webshot = require("webshot");
var async = require("async");
var fs = require("fs");
var clc = require("cli-color");
var schedule = require("node-schedule");
var noop = function() {};
var globalOptions;

var startColor = clc.bold.underline.greenBright;
var jobColor = clc.green;

var runSchedule = function(captureConfig) {
  console.log(startColor("\nStarting schedule...\n"));

  schedule.scheduleJob(captureConfig.schedule, function() {
    var start = Date.now();
    console.log(jobColor("Preforming job at ") + clc.cyan(new Date().toUTCString() + "\n"));
    capture(captureConfig, function(session) {
      writeSession(captureConfig, session, function() {
        var time = (Date.now() - start) / 1000;
        console.log(jobColor("\nJob finished in ") + time + "s\n");
      });
    });
  });
};

var capture = function(config, callback) {
  globalOptions = config.options || {}; 

  async.map(config.captures, processCapture, function(err, results) {
    var session = {shots: results};
    (callback || noop)(session);
  });
};

var writeSession = function(config, session, callback) {
  var timestamp = config.schedule && config.timestamp !== false;
  var output = config.output;
  // Add a timestamp for scheduled tasks unless timestamp is false in config
  if (timestamp) {
    output = output.replace(".pdiffy", "." + Date.now() + ".pdiffy");
  }

  fs.writeFile(output, JSON.stringify(session), function(err) {
    if (err) throw err;
    console.log(clc.blue("Session written to ") + clc.cyan(output));
    (callback || noop)();
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
module.exports.writeSession = writeSession;
module.exports.runSchedule = runSchedule;

var fs = require("fs");
var utils = require("./utils");
var status = require("./console");

var removeBuffers = function(results) {
  results.forEach(function(result) {
    delete result.imageBuffer;
  });
};

var writeSession = function(config, session, callback) {
  var timestamp = (config.schedule || config.interval) && config.timestamp !== false;
  var output = config.output;
  // Add a timestamp for scheduled tasks unless timestamp is false in config
  if (timestamp) {
    output = output.replace(".pdiffy", "." + Date.now() + ".pdiffy");
  }

  removeBuffers(session.shots);

  fs.writeFile(output, JSON.stringify(session), function(err) {
    if (err) throw err;
    status.log(status.info("Session written to ") + status.data(output));
    (callback || utils.noop)();
  });
};

module.exports.writeSession = writeSession;

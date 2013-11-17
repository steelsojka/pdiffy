var capture = require("./capture");
var combine = require("./combine");

module.exports.capture = capture.capture;
module.exports.writeSession = capture.writeSession;
module.exports.runSchedule = capture.runSchedule;

module.exports.startServer = function() {
  return require("../server/server");
};

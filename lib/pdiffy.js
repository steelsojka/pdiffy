var capture = require("./capture");
var combine = require("./combine");

module.exports.capture = capture.capture;
module.exports.performJob = capture.performJob;
module.exports.writeSession = capture.writeSession;
module.exports.runSchedule = capture.runSchedule;
module.exports.runInterval = capture.runInterval;
module.exports.combine = combine.combine;

module.exports.startServer = function() {
  return require("../server/server");
};

var capture = require("./capture");
var schedule = require("./schedule");
var combine = require("./combine");
var io = require("./io");

module.exports.capture = capture.capture;
module.exports.compare = capture.compare;
module.exports.performJob = schedule.performJob;
module.exports.writeSession = io.writeSession;
module.exports.runSchedule = schedule.runSchedule;
module.exports.runInterval = schedule.runInterval;
module.exports.combine = combine.combine;

module.exports.startServer = function() {
  return require("../server/server");
};

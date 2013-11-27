var schedule = require("node-schedule");
var _ = require("lodash");
var status = require("./console");
var clc = require("cli-color");
var capture = require("./capture").capture;
var writeSession = require("./io").writeSession;
var utils = require("./utils");
var jobRunning = false;

var runSchedule = function(captureConfig) {
	if (!_.isObject(captureConfig.schedule)) {
		status.warn("schedule must be an object");
		return;
	}

  status.break().exec(status.start("starting schedule...")).break();
  schedule.scheduleJob(captureConfig.schedule, _.partial(performJob, captureConfig));
};

var run = function(captureConfig, callback) {
  if (captureConfig.schedule) {
    runSchedule(captureConfig);
  } else if (captureConfig.interval) {
    runInterval(captureConfig);
  } else {
    performJob(captureConfig, callback);
  }
};

var performJob = function(captureConfig, callback) {

	if (jobRunning) { 
    status.warn("job is already running");
    return;
  }

  callback = callback || utils.noop;

	var start = Date.now();

  var onJobEnd = function(session) {
    var time = (Date.now() - start) / 1000;
    status.break().info(status.job("job finished in ") + time + "s\n");
    jobRunning = false;
    callback(session);
  };

	jobRunning = true;

	status.exec(clc.green("performing job at ") + status.data(new Date().toUTCString() + "\n"));

	capture(captureConfig, function(session) {
    if (captureConfig.output) {
      writeSession(captureConfig, session, onJobEnd);
    } else {
      onJobEnd(session);
    }
	});
};

var runInterval = function(captureConfig) {
	status.break().log(status.start("starting interval capture...")).break();

	if (!_.isNumber(captureConfig.interval)) {
		status.warn("interval must be an integer");
		return;
	}

	setInterval(_.partial(performJob, captureConfig), captureConfig.interval * 60 * 1000);
};

module.exports.run = run;
//module.exports.runSchedule = runSchedule;
//module.exports.runInterval = runInterval;
//module.exports.performJob = performJob;

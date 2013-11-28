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

  status.info(status.start("starting schedule..."));
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
    status.error("job is already running");
    return;
  }

  callback = callback || utils.noop;

	var start = Date.now();

  var onJobEnd = function(session) {
    var time = (Date.now() - start) / 1000;
    status.info(status.job("job finished in ") + time + "s");
    jobRunning = false;
    callback(session);
  };

	jobRunning = true;

	status.exec(clc.green("running job at ") + status.data(new Date().toUTCString()));

	capture(captureConfig, function(session) {
    if (captureConfig.output) {
      writeSession(captureConfig, session, onJobEnd);
    } else {
      onJobEnd(session);
    }
	});
};

var runInterval = function(captureConfig) {
	status.info(status.start("starting interval capture..."));

	if (!_.isNumber(captureConfig.interval)) {
		status.error("interval must be an integer");
		return;
	}

	setInterval(_.partial(performJob, captureConfig), captureConfig.interval * 60 * 1000);
};

module.exports.run = run;

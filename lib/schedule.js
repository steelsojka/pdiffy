var schedule = require("node-schedule");
var _ = require("lodash");
var status = require("./console");
var capture = require("./capture").capture;
var writeSession = require("./io").writeSession;
var utils = require("./utils");
var jobRunning = false;

var runSchedule = function(captureConfig) {
	if (!_.isObject(captureConfig.schedule)) {
		status.log(status.warn("WARN") + " schedule must be an object");
		return;
	}

  status.break().log(status.start("Starting schedule...")).break();
  schedule.scheduleJob(captureConfig.schedule, _.partial(performJob, captureConfig));
};

var performJob = function(captureConfig, callback) {

	if (jobRunning) { return; }

	var start = Date.now();
	jobRunning = true;

	status.log(status.job("Preforming job at ") + status.data(new Date().toUTCString() + "\n"));

	capture(captureConfig, function(session) {
		writeSession(captureConfig, session, function() {
			var time = (Date.now() - start) / 1000;
			status.break().log(status.job("Job finished in ") + time + "s\n");
			jobRunning = false;
			(callback || utils.noop)(session);
		});
	});
};

var runInterval = function(captureConfig) {
	status.break().log(status.start("Starting interval capture...")).break();

	if (!_.isNumber(captureConfig.interval)) {
		status.log(status.warn("WARN") + " interval must be an integer");
		return;
	}

	setInterval(_.partial(performJob, captureConfig), captureConfig.interval * 60 * 1000);
};

module.exports.runSchedule = runSchedule;
module.exports.runInterval = runInterval;
module.exports.performJob = performJob;

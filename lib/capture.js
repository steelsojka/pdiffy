var _ = require("lodash");
var webshot = require("webshot");
var async = require("async");
var fs = require("fs");
var schedule = require("node-schedule");
//var PNGDecoder = require("png-js");
var PNG = require("pngjs").PNG;
var status = require("./console");
var difference = require("./difference");
var noop = function() {};
var globalOptions;
var jobRunning = false;

var runSchedule = function(captureConfig) {
	if (!_.isObject(captureConfig.schedule)) {
		console.log(status.warn("WARN") + " schedule must be an object");
		return;
	}

  console.log(status.start("\nStarting schedule...\n"));
  schedule.scheduleJob(captureConfig.schedule, _.partial(performJob, captureConfig));
};

var performJob = function(captureConfig, callback) {

	if (jobRunning) { return; }

	var start = Date.now();
	jobRunning = true;

	console.log(status.job("Preforming job at ") + status.data(new Date().toUTCString() + "\n"));
	capture(captureConfig, function(session) {
		writeSession(captureConfig, session, function() {
			var time = (Date.now() - start) / 1000;
			console.log(status.job("\nJob finished in ") + time + "s\n");
			jobRunning = false;
			(callback || noop)(session);
		});
	});
};

var runInterval = function(captureConfig) {
	console.log(status.start("\nStarting interval capture...\n"));

	if (!_.isNumber(captureConfig.interval)) {
		console.log(status.warn("WARN") + " interval must be an integer");
		return;
	}

	setInterval(_.partial(performJob, captureConfig), captureConfig.interval * 60 * 1000);
};

var capture = function(config, callback) {
  globalOptions = config.options || {}; 

  async.map(config.captures, processCapture, function(err, results) {
    var session = {shots: []};

    // Concat all our shots together
    results.forEach(function(shotArray) {
      session.shots.push.apply(session.shots, shotArray);
    });

   (callback || noop)(session);
  });
};

var writeSession = function(config, session, callback) {
  var timestamp = (config.schedule || config.interval) && config.timestamp !== false;
  var output = config.output;
  // Add a timestamp for scheduled tasks unless timestamp is false in config
  if (timestamp) {
    output = output.replace(".pdiffy", "." + Date.now() + ".pdiffy");
  }

  fs.writeFile(output, JSON.stringify(session), function(err) {
    if (err) throw err;
    console.log(status.info("Session written to ") + status.data(output));
    (callback || noop)();
  });
};

var processCapture = function(capture, callback) {
  var results = {}; 
  var options = _.extend(globalOptions, (capture.options || {}));
  var differenceFlag = _.isArray(capture.url);
  var shots = differenceFlag ? capture.url : [capture.url];

  async.map(shots, function(url, cb) {
    var imageData = "";
    var imageBuffer = new Buffer(0);

		console.log(status.info("Capturing: ") + url);

    webshot(url, options, function(err, stream) {
      if (err) throw err;

      stream.on('data', function(data) {
        imageData += data.toString('base64');
        imageBuffer = Buffer.concat([imageBuffer, data]);
      });

      stream.on('end', function() {

        console.log(status.success("Done") + " " + url);

        cb(null, {
          path: "data:image/png;base64," + imageData,
          displayURL: url,
          imageBuffer: imageBuffer
        });
      });
    });
  }, function(err, results) {
		if (err) throw err;

		if (differenceFlag) {
			performDiff(results, capture, function(results) {
        removeBuffers(results);
        callback(err, results);
      });	
		} else {
      removeBuffers(results);
			callback(err, results); 
		}
  });
};

var removeBuffers = function(results) {
  results.forEach(function(result) {
    delete result.imageBuffer;
  });
};

var performDiff = function(results, capture, callback) {
  async.map(results, function(shot, cb) {
    console.log("Parsing " + shot.displayURL);

    var png = new PNG({
      filterType: -1
    });

    png.on('parsed', function() {
      cb(null, this);
    });

    png.on('error', function(err) {
      throw err;
    });

    png.parse(shot.imageBuffer);

/*    png.decode(function(pixels) {
      cb(null, {
        height: png.height,
        width: png.width,
        data: pixels
      });*/
//    });

  }, function(err, pngs) {
    var width = _(pngs).pluck("width").max().value();
    var height = _(pngs).pluck("height").max().value();

    var diffPng = new PNG({
      width: width,
      height: height,
      filterType: -1
    });

    var buffers = pngs.map(function(buf) {
      return {data: buf};
    });

    var diffData = difference.compute({
      id: _.uniqueId(),
      mode: capture.mode || "heatmap",
      threshold: 0,
      imageData: buffers,
      contextData: diffPng,
      startY: 0,
      block: height
    });

    var diffBuffer = new Buffer(0);

    diffPng.on('data', function(data) {
      diffBuffer = Buffer.concat([diffBuffer, data]);
    });

    diffPng.on('error', function(err) {
      throw err;
    });

    diffPng.on('end', function() {
      results.push({
        path: "data:image/png;base64," + diffBuffer.toString("base64"),
        displayURL: "Difference"
      });

      callback(results);
    });

    diffPng.pack();
  });
};


module.exports.capture = capture;
module.exports.writeSession = writeSession;
module.exports.runSchedule = runSchedule;
module.exports.runInterval = runInterval;
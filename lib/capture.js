var _ = require("lodash");
var webshot = require("webshot");
var async = require("async");
var fs = require("fs");
var PNGDecoder = require("png-js");
var PNG = require("pngjs").PNG;
var status = require("./console");
var clc = require("cli-color");
var difference = require("./difference");
var utils = require("./utils");
var globalOptions;
var noop = utils.noop;


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

var processCapture = function(capture, callback) {
  var results = {}; 
  var options = _.extend(globalOptions, (capture.options || {}));
  var differenceFlag = _.isArray(capture.url);
  var shots = differenceFlag ? capture.url : [capture.url];

  async.map(shots, function(url, cb) {
    var imageData = "";
    var imageBuffer = new Buffer(0);

		status.log(status.info("Capturing: ") + url);

    webshot(url, options, function(err, stream) {
      if (err) throw err;

      stream.on('data', function(data) {
        imageData += data.toString('base64');
        imageBuffer = Buffer.concat([imageBuffer, data]);
      });

      stream.on('end', function() {

        status.log(status.success("Done") + " " + url);

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
        callback(err, results);
      });	
		} else {
			callback(err, results); 
		}
  });
};

var performDiff = function(results, capture, callback) {
  capture = capture || {};

  async.map(results, function(shot, cb) {
    status.log(status.info("Parsing: ") + shot.displayURL);

    var png = new PNGDecoder(shot.imageBuffer);
/*
    png.on('parsed', function() {
      cb(null, this);
    });

    png.on('error', function(err) {
      throw err;
    });

    png.parse(shot.imageBuffer);*/

    png.decode(function(pixels) {
      cb(null, {
        height: png.height,
        width: png.width,
        data: pixels
      });
    });

  }, function(err, pngs) {
    var width = _(pngs).pluck("width").max().value();
    var height = _(pngs).pluck("height").max().value();

    var diffPng = new PNG({
      width: width,
      height: height,
      filterType: -1
    });

    // This makes all PNGS the same size when comparing
    var buffers = pngs.map(function(buf) {
      var png = new PNG({
        width: width,
        height: height,
        filterType: -1
      });

      png.bitblt.call(buf, png, 0, 0, buf.width, buf.height, 0, 0);

      return {data: png};
    });

    var diffData = difference.compute({
      id: _.uniqueId(),
      mode: capture.mode || "block",
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
      var diffShot = {
        path: "data:image/png;base64," + diffBuffer.toString("base64"),
        displayURL: "Difference",
        data: diffData.stats
      };

      results.push(diffShot);
      callback(results, diffShot);
    });

    diffPng.pack();
  });
};

var compare = function(options) {
  async.map(options.paths, function(path, callback) {
    if (utils.isUrl(path)) {
      capture({options: options.captureOptions, captures: [{url: path}]}, function(session) {
        callback(null, session.shots[0]);
      });
    } else {
      if (!fs.existsSync(path)) {
        throw new Error("File does not exist!");
      }

      var buffer = fs.readFileSync(path);

      callback(null, {
        displayURL: path,
        imageBuffer: buffer
      });
    }
  }, function(err, results) {
    performDiff(results, options.diffOptions, function(shots, diffShot) {
      status.break().log(clc.green("File written to ") + clc.cyan(options.output));
      if (options.output) {
        fs.writeFileSync(options.output, diffShot.path.replace(/^data:image\/png;base64,/,""), "base64") 
      } else {
        options.callback(diffShot.path);
      }
    });
  });
};

module.exports.performDiff = performDiff;
module.exports.capture = capture;
module.exports.compare = compare;

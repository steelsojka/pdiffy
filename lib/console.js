var clc = require("cli-color");

module.exports.success = clc.bgGreen.black;
module.exports.data = clc.cyan;
module.exports.start = clc.bold.underline.greenBright;
module.exports.job = clc.green;

module.exports.exec = function(msg) {
  this.log(clc.magenta("EXEC") + " " + msg);
  return this;
};

module.exports.warn = function(msg) {
  this.log(clc.gbRed.black("WARN") + " " + msg);
  return this;
};

module.exports.info = function(msg) {
  this.log(clc.blue("INFO") + " " + msg);
  return this;
};

module.exports.done = function(msg) {
  this.log(clc.bgYellow.black("DONE") + " " + msg);
  return this;
};

module.exports.break = function() {
  console.log("");
  return this;
};

module.exports.log = function(msg) {
  console.log(clc.cyan("pdiffy ") + msg);
  return this;
};

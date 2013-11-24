var clc = require("cli-color");

module.exports.success = clc.bgGreen.black;
module.exports.info = clc.blue;
module.exports.data = clc.cyan;
module.exports.start = clc.bold.underline.greenBright;
module.exports.job = clc.green;
module.exports.warn = clc.bgRed.black;
module.exports.break = function() {
  console.log("");
  return this;
};

module.exports.log = function(msg) {
  console.log(clc.cyan("pdiffy ") + msg);
  return this;
};

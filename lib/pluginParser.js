var _ = require("lodash");
var fs = require("fs");

var parse = function(plugins) {

  var outputCode = "function() { pdiffy = {};\n";

  var pluginStrings = _.map(plugins, function(params, pluginName) {
    var code = fs.readFileSync(__dirname + "/plugins/" + pluginName + ".js").toString();

    var injectables = "pdiffy." + pluginName + " = " + JSON.stringify(params) + ";";

    return injectables + "\n" + code;
  });


  return outputCode += pluginStrings.join("\n") + "}";
};

module.exports.parse = parse;

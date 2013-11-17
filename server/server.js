var express = require("express");
var io = require("socket.io");
var http = require("http");
var path = require("path");
var _ = require("lodash");
var fs = require("fs");
var rootPath = path.normalize(__dirname + "/../");

/*
if (!fs.existsSync(process.cwd() + "pdiffy.config.json")) {
  console.log("No config file exists in working directory! Using default.");
  var configDefaults = fs.readFileSync(rootPath + "server/config-defaults.json", {encoding: "utf-8"});
  fs.writeFileSync("config.json", configDefaults);
}*/

var config = require("./config-defaults.json");

var app = exports.app = express();

app.set("port", config.port);

app.configure("development", function() {
  app.use(express.errorHandler({
    dumpExceptions: true,
         showStack: true
  }));

  app.use(express.static(path.join(__dirname, './../.tmp')));
  app.use(express.static(path.join(__dirname, './../app')));
});

app.configure("production", function() {
  app.use(express.errorHandler());
  app.use(express.static(path.join(__dirname, './../dist')));
});

var server = http.createServer(app)

exports.io = io.listen(server.listen(app.get("port"), function() {
  console.log("Application running at http://localhost:" + app.get("port") + " on " + process.env.NODE_ENV);
}));

process.on('kill', function() {
  console.log("Killing server...");
  server.close();
});

require("./sockets");
require("./routes");


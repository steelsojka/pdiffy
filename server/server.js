var express = require("express");
var io = require("socket.io");
var http = require("http");
var path = require("path");
var _ = require("lodash");
var config = require("../config.json");

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
  app.use(express.static(path.join(__dirname, './../dist/app')));
});


exports.io = io.listen(http.createServer(app).listen(app.get("port"), function() {
  console.log("Application running at http://localhost:" + app.get("port") + " on " + process.env.NODE_ENV);
}));

require("./sockets");
require("./routes");


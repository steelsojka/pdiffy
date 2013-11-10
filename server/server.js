var express = require("express");
var io = require("socket.io");
var http = require("http");
var path = require("path");
var _ = require("lodash");

var app = exports.app = express();

app.set("port", 9000);

app.configure("development", function() {
  app.use(express.errorHandler({
    dumpExceptions: true,
         showStack: true
  }));

  app.use(express.static(path.join(__dirname, './../.tmp')));
});

app.configure("production", function() {
  app.use(express.errorHandler());
});

app.use(express.static(path.join(__dirname, './../app')));

exports.io = io.listen(http.createServer(app).listen(app.get("port"), function() {
  console.log("Application running at http://localhost:" + app.get("port"));
}));

require("./sockets");
require("./routes");


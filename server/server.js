var express = require("express");
var io = require("socket.io");
var http = require('http');

var app = exports.app = express();

app.get("/", function(req, res) {
	var body = "You got me!";
	res.setHeader("Content-Type", "text/plain");
	res.setHeader("Content-Length", body.length);
	res.end(body);
});

app.set('port', 9000);

app.configure('development', function() {
    app.use( express.errorHandler( { dumpExceptions: true, showStack: true } ) );
});

app.configure('production', function() {
    app.use( express.errorHandler() );
});

exports.io = io.listen(http.createServer(app).listen(app.get('port'), function() {
	console.log("Application running at http://localhost:" + app.get('port'));
}));

require('./sockets');

'use strict';

// Main sockets object
var io = require( './../server' ).io;
var webshot = require("webshot");
var fs = require('fs');
var _ = require("lodash");

// Connection route - bootstraps the other socket routes
io.sockets.on('connection', function( socket ) {

	socket.emit('send:onConnect', {
		message: 'Sockets Connected',
    data: {}
	});

  socket.on("send:takeShot", function(shot) {
    webshot(shot.url, _.omit(shot, "url"), function(err, stream) {
      stream.on('data', function(data) {
        socket.emit('data:chunk', {data: data.toString('binary')});
      });

      stream.on("end", function() {
        socket.emit('data:end', {
          message: 'Data End'
        });
      });
    });
  });

  socket.on("send:getConfig", function() {
    var config = fs.readFile("server/config-defaults.json", {encoding: "utf-8"}, function(err, data) {
      if (err) throw err;
      socket.emit("data:config", data);
    });
  });

  socket.on("send:saveConfig", function(config) {
/*    fs.writeFile("config.json", JSON.stringify(config, null, "\t"), function(err) {
      if (err) throw err;
    });*/
  });

	// Example socket
	// @todo remove the requirement to pass in the socket
	// require( './example' )( socket );

});

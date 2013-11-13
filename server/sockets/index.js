'use strict';

// Main sockets object
var io = require( './../server' ).io;
var webshot = require("webshot");
var fs = require('fs');

// Connection route - bootstraps the other socket routes
io.sockets.on('connection', function( socket ) {

	socket.emit('send:onConnect', {
		message: 'Sockets Connected',
    data: {}
	});

  socket.on("send:takeShot", function(shot) {
    webshot(shot.url, function(err, stream) {
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

	// Example socket
	// @todo remove the requirement to pass in the socket
	// require( './example' )( socket );

});

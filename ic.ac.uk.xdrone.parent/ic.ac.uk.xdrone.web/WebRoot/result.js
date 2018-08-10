var arDrone = require('/usr/local/lib/node_modules/ar-drone'); 
var http    = require('http');
var fs		= require('fs');

var option = new Object();
option.imageSize = "1280x720";
var client = arDrone.createClient(option);
var pngStream = client.getPngStream();

client.takeoff();

var lastPng;
pngStream
  .on('error', console.log)
  .on('data', function(pngBuffer) {
    lastPng = pngBuffer;
  });
  
client
  .after(5000, function() {
  this.stop();
  this.up(0.2);
})
.after(1000, function() {
  this.stop();
  this.counterClockwise(0.5);
})
.after(1000, function() {
fs.writeFile('WebRoot/images/ashman.png', lastPng, (err) => {});
  this.stop();
  this.clockwise(0.5);
})
.after(1000, function() {
   this.stop();
   this.land();
  }).after(5000, function () {
  	process.exit(0);
  });


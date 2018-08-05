var arDrone = require('/usr/local/lib/node_modules/ar-drone'); 
var http    = require('http');
var fs		= require('fs');

var client  = arDrone.createClient();

console.log('Connecting png stream ...');
var pngStream = arDrone.createClient().getPngStream();

client.takeoff();

var lastPng;
pngStream
  .on('error', console.log)
  .on('data', function(pngBuffer) {
    lastPng = pngBuffer;
  });
  
client
  .after(5000, function() {
fs.writeFile('WebRoot/images/Other.png', lastPng, (err) => {});
   this.stop();
   this.land();
  }).after(5000, function () {
  	process.exit(0);
  });


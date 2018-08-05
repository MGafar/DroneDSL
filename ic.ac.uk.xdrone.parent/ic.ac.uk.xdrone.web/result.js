var arDrone = require('/usr/local/lib/node_modules/ar-drone'); 
var client  = arDrone.createClient();
client.takeoff();
client
  .after(5000, function() {
  this.stop();
  this.back(0.1);
})
.after(11, function() {
   this.stop();
   this.land();
  }).after(5000, function () {
  	process.exit(0);
  });


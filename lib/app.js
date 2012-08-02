var AaRr = require('./AaRr.js');
var aarr = new AaRr();
aarr.server.start(aarr.options, function(err, msg){
	if(err)throw err;
	console.log(msg);
});
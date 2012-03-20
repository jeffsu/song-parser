var server = require('./server');
var router = require('./router');
var requestHandlers = require('./requestHandlers');

var handle = {}; 
handle["/"] = requestHandlers.start; 
handle["/parse"] = requestHandlers.parse;
  
server.start(router.route, handle); 

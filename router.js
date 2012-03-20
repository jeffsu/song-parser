function route(handle, pathname, response, songtext) {
  console.log("About to process request for " + pathname);

  if (typeof handle[pathname] === 'function') { 
    handle[pathname](response, songtext); 
  }
  else {
    console.log("No request handler for " + pathname); 
  }
}

exports.route = route; 

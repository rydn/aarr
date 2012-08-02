/**
 * Exports
 */
exports.start = function(options, callback) {
  /**
   * Module dependencies.
   */
  var express = require('express'),
    http = require('http'),
    path = require('path');

  var app = express();
  /**
   * Setup
   */
  app.configure(function() {
    app.set('port', options.port);
    app.set('views', __dirname + '/views');
    app.use(express.favicon());
    app.use(express.logger('dev'));
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(app.router);
    app.use(express.static(options.publicDir));
  });
  /**
   * Config
   */
  app.configure('development', function() {
    app.use(express.errorHandler());
  });
  /**
   * Routes
   */
  http.createServer(app).listen(app.get('port'), function() {
    callback(null, "\n\nAaRr HTTP Service listening on port: " + app.get('port') + '\nServing Dir: '+path.join(__dirname, options.publicDir));
  });
};
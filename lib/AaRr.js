/**
*	Dependencies
*/
//	settings
var config = require('./config.js');
// deps
var path = require('path');
/**
 *  Expose `aarr`.
 */

module.exports = AaRr;

/**
 * init.
 * Inits a instance of aarr with either supplied options or defaults
 * @param {Object} options
 */
function AaRr(options) {
  //options
  this.options = options || {port:8000, bind:"localhost", publicDir:path.resolve("../out/")};
}

/**
 * Component inports
 */
//	http server
AaRr.prototype.server = require('./layers/services/http.js');


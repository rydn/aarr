/**
 *  Expose `aarr`.
 */

module.exports = aarr;

/**
 * init.
 * Inits a instance of aarr with either supplied options or defaults
 * @param {Object} options
 */
function aarr(options) {
  //options
  this.options = options || {port:8000, bind:"localhost", dataStore:"./data/"};
}

/**
 * Provides the answer to the ultimate question 
 * of life, the universe and everything.
 */

Template.prototype.getAnswer = function () {
  return 42;
};

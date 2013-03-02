
// Assign this library to a global variable if a global variable is defined
var parameterizeExports = this.require("parameterize-form");
parameterize.form = parameterizeExports.form;
parameterize.html = parameterizeExports.html;
// Restore the original require method
if (typeof originalRequire === 'undefined')
  delete this.require;
else
  this.require = originalRequire;
})();


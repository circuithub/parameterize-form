
// Assign this library to a global variable if a global variable is defined
var parameterizeExports = this.require("parameterize-form");
var k;
for (k in parameterizeExports)
  parameterize[k] = parameterizeExports[k];
// Restore the original require method
if (typeof originalRequire === 'undefined')
  delete this.require;
else
  this.require = originalRequire;
})();


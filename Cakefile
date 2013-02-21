fs     = require 'fs'
path   = require 'path'
{exec} = require 'child_process'

###
Tasks
###

task 'build', "Build the client-side js version of this library", ->
  stitch  = require 'stitch'
  cp = (ipath, opath, cb) ->
    readStream = fs.createReadStream ipath
    readStream.pipe(fs.createWriteStream opath).on "close", cb
  
  cp "#{__dirname}/node_modules/adt.js/dist/adt.js", "#{__dirname}/vendor/adt.js", ->
    cp "#{__dirname}/node_modules/adt-html.js/dist/adt-html.js", "#{__dirname}/vendor/adt-html.js", ->
      pkg = stitch.createPackage paths: ["#{__dirname}/lib", "#{__dirname}/vendor"]
      pkg.compile (err, source) ->
        fs.writeFile "dist/parameterize-form.js", source, (err) ->
          if err
            throw err
          console.log "Compiled parameterize-form.js"


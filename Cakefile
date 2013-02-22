fs            = require 'fs'
path          = require 'path'

# {print}       = require 'util'
which         = require 'which'
{spawn, exec} = require 'child_process'
stitch        = require 'stitch'
uglify        = require 'uglify-js'

# ANSI Terminal Colors
bold  = '\x1B[0;1m'
red   = '\x1B[0;31m'
green = '\x1B[0;32m'
reset = '\x1B[0m'

log = (message, color, explanation) -> console.log color + message + reset + ' ' + (explanation or '')

###
Tasks
###

pack = (callback) ->
  cp = (ipath, opath, cb) ->
    readStream = fs.createReadStream ipath
    readStream.pipe(fs.createWriteStream opath).on "close", cb

  cp "#{__dirname}/node_modules/adt.js/dist/adt.js", "#{__dirname}/vendor/adt.js", ->
    cp "#{__dirname}/node_modules/adt-html.js/dist/adt-html.js", "#{__dirname}/vendor/adt-html.js", ->
      cp "#{__dirname}/node_modules/parameterize-adt/dist/parameterize-adt.js", "#{__dirname}/vendor/parameterize-adt.js", ->
        pkg = stitch.createPackage paths: ["#{__dirname}/build", "#{__dirname}/vendor"]
        pkg.compile (err, source) ->
          fs.writeFile "dist/parameterize-form.js", source, (err) ->
            if err
              throw err
            console.log "Compiled parameterize-form.js"
            #ast = uglify.parser.parse source
            #ast = uglify.uglify.ast_squeeze ast
            #uglified_source = uglify.uglify.gen_code ast
            ###
            shasum = crypto.createHash("sha1")
            shasum.update(uglified_source)
            ###
            #fs.writeFileSync libAssetPath, uglified_source
            #fs.writeFileSync libAssetPath, source
            callback?()

build = (callback) ->
  options = ['-c','-b', '-o', 'build', 'src']
  cmd = which.sync 'coffee'
  coffee = spawn cmd, options
  coffee.stdout.pipe process.stdout
  coffee.stderr.pipe process.stderr
  coffee.on 'exit', (status) -> callback?() if status is 0
  
task 'build', "Build the client-side js version of this library", ->
  build pack -> log ":)", green


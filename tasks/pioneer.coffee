module.exports = (grunt) ->
  grunt.registerTask 'pioneer', 'Grunt task for running Pioneer', ->
    _ = grunt.util._

    {features, steps, widgets, format, driver, coffee} = @options()

    execOptions = []

    if _.isEmpty features
      optionsString = JSON.stringify @options(), null, '  '
      grunt.fail.warn "'features' option is required -- not found in: \n\n#{optionsString}\n\n"
    else
      execOptions.push features

    unless _.isEmpty steps
      execOptions.push '--require'
      execOptions.push steps

    unless _.isEmpty widgets
      execOptions.push '--require'
      execOptions.push widgets

    unless _.isEmpty driver
      execOptions.push '--driver'
      execOptions.push driver

    unless _.isEmpty format
      execOptions.push '--format'
      execOptions.push format

    if coffee
      execOptions.push '--coffee'

    grunt.verbose.writeln 'Exec Options: ' + execOptions.join ' '

    done = @async()

    spawn = require('child_process').spawn
    proc = spawn './node_modules/.bin/pioneer', execOptions
    proc.stdout.on 'data', (data) ->
      grunt.log.writeln data.toString().trimRight()

    proc.on 'exit', (code) ->
      done code is 0

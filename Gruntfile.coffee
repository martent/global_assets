module.exports = (grunt) ->
  util = require 'util'

  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-clean'

  env = grunt.option("env") or 'development'
  audience = grunt.option('audience') or "internal"

  grunt.initConfig
    env: grunt.file.readYAML('config/env.yml')[env]
    audience: grunt.file.readYAML('config/audience.yml')[audience][env]
    pkg: grunt.file.readJSON('package.json')
    foo: "<%= audience.sv_base_url %>"

  grunt.registerTask 'foo', ->
    grunt.log.writeln grunt.config("pkg.name")
    grunt.log.writeln grunt.config("env.sass_style")
    grunt.log.writeln grunt.config("audience.sv_base_url")
    grunt.log.writeln util.inspect grunt.config("env")
    grunt.log.writeln util.inspect grunt.config("audience")
    grunt.log.writeln grunt.config("foo")

  grunt.registerTask "default", ["foo"]

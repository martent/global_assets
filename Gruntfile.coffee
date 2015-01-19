module.exports = (grunt) ->
  util = require 'util'

  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-template'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-clean'

  env = grunt.option("env") or "development"
  audience = grunt.option('audience')
  audiences = ["internal", "external"]

  if audiences.indexOf(audience) is -1
    grunt.fail.fatal "You most specify an audience:\n\n  grunt --audience=[#{audiences}]\n"

  grunt.initConfig
    env: grunt.file.readYAML('config/env.yml')[env]
    audience: grunt.file.readYAML('config/audience.yml')[audience][env]
    pkg: grunt.file.readJSON('package.json')
    foo: "<%= audience.sv_base_url %>"

    clean: ["build/*.*", "dist/*.*"]

    sass:
      compile:
        options:
          style: "<%= env.sass_style %>"
          sourcemap: "<%= env.source_maps %>"
        files: [
          expand: true
          src: [
            # Use the Sass declarations `@import` in the main scss file application.scss
            'app/assets/stylesheets/foo.scss'
            'app/assets/stylesheets/legacy/ie8.scss'
          ]
          dest: 'dist'
          ext: '.css'
        ]

  grunt.registerTask 'foo', ->
    grunt.log.writeln grunt.config("pkg.name")
    grunt.log.writeln grunt.config("env.sass_style")
    grunt.log.writeln grunt.config("audience.sv_base_url")
    grunt.log.writeln util.inspect grunt.config("env")
    grunt.log.writeln util.inspect grunt.config("audience")
    grunt.log.writeln grunt.config("foo")

  grunt.registerTask 'build', ["clean", "sass"]
  grunt.registerTask "default", ["build"]

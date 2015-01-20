module.exports = (grunt) ->
  util = require 'util'

  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-template'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-template'
  grunt.loadNpmTasks 'grunt-grunticon'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-clean'

  env = grunt.option("env") or "development"
  audience = grunt.option('audience')
  audiences = ["internal", "external"]

  if grunt.file.defaultEncoding isnt 'utf8'
    grunt.fail.fatal("Your environments encoding is #{grunt.file.defaultEncoding} but must be 'utf8'")

  if audiences.indexOf(audience) is -1
    grunt.fail.fatal "You most specify an audience:\n\n  grunt --audience=[#{audiences}]\n"

  grunt.initConfig
    env: grunt.file.readYAML('config/env.yml')[env]
    audience: grunt.file.readYAML('config/audience.yml')[audience][env]
    pkg: grunt.file.readJSON('package.json')
    foo: "<%= audience.sv_base_url %>"

    clean:
      build: "build/*"
      dist: "dist/*"

    watch:
      sass:
        files: 'app/assets/**/*.{scss,scss.tpl,css}'
        tasks: ['build']
      # coffee:
      #   files: 'app/assets/**/*.{coffee,js,js.tpl}'
      #   tasks: ['build']
      options:
        reload: true
        liveReload: true
        atBegin: true

    grunticon:
      icons:
        files: [
          expand: true,
          cwd: 'masters/icons',
          src: ['*.svg', '*.png'],
          dest: 'app/assets/icons'
        ]
        options:
          datasvgcss: "icons.data.svg.css"
          datapngcss: "icons.data.png.css"
          urlpngcss: "icons.fallback.css"
          cssprefix: '.m-icon-'
          customselectors:
            "chevron-right": [".breadcrumbs li"]
            "caret-down-0": [".box-menu .dropdown-toggle"]
            "todo-0": [".act-now a::before"]
          cssbasepath: '/'

    template:
      'process-html-template':
        options:
          data:
            audience: audience
            env: env
        files:
          'build/malmo.scss': ['build/malmo.scss.tpl']
          'build/masthead_standalone.scss': ['build/masthead_standalone.scss.tpl']

    copy:
      main:
        files: [
          {expand: true, cwd: 'app/assets/stylesheets/', src: ['**'], dest: 'build/'}
          {expand: true, cwd: 'vendor/malmo_shared_assets/stylesheets/', src: ['**'], dest: 'build/'}
          {expand: true, cwd: 'vendor/assets/', src: ['fonts/*.*'], dest: 'build/', filter: 'isFile' }
          {expand: true, cwd: 'node_modules/bootstrap-sass/assets/stylesheets/', src: ['**'], dest: 'build/'}
          {expand: true, cwd: 'node_modules/bootstrap-datepicker/css/', src: ['**'], dest: 'build/'}
          {expand: true, cwd: 'app/assets/icons/', src: ['**'], dest: 'dist/'}
          {src: ['node_modules/bootstrap-datepicker/css/datepicker3.css'], dest: 'build/datepicker3.scss'}
          {src: ['vendor/assets/stylesheets/jquery-ui.helpers.min.css'], dest: 'build/jquery-ui.helpers.min.scss'}
        ]

    sass:
      compile:
        options:
          style: "<%= env.sass_style %>"
          sourcemap: "<%= env.source_maps %>"
          lineNumbers: true
          precision: 10
          loadPath: [
            "build/shared"
            "build/#{audience}"
          ]
        files: [
          cwd: "build"
          expand: true
          src: [
            # Use the Sass declarations `@import` in the main scss file application.scss
            'malmo.scss'
            'legacy/ie8.scss'
            'masthead_standalone.scss'
            'portwise.scss'
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

  grunt.registerTask "default", ["build"]
  grunt.registerTask 'build', ["clean", "copy", "template", "sass", "clean:build"]
  grunt.registerTask 'icons', ['grunticon:icons']

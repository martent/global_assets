module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-clean'

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    audience:
      internal: grunt.file.readYAML('config/application_internal.yml')
      external: grunt.file.readYAML('config/application_external.yml')

    banner: '/*! <%= pkg.name %> <%= pkg.version %> <%= grunt.template.today("yyyy-mm-dd hh:mm:ss") %> */'
    forDist: false
    generateSourceMaps: true

    # $ grunt sass
    sass:
      compile:
        options:
          style: '<%= forDist ? "compressed" : "expanded" %>'
          banner: '<%= banner %>'
          sourcemap: '<%= generateSourceMaps ? "file" : "none" %>'
        files: [
          expand: true
          cwd: 'src/stylesheets'
          src: [
            # Use the Sass declarations `@import` in the main scss file application.scss
            'application.scss'
            # Individual files
            'ie7.scss'
          ]
          dest: '<%= forDist ? "dist" : "public" %>'
          ext: '.css'
        ]

    # $ grunt coffee
    coffee:
      compile:
        options:
          sourceMap: '<%= generateSourceMaps %>'
        files:
          '<%= forDist ? "dist" : "public" %>/application.js': [
            # Files to compile and concatenate in given order
            'src/javascripts/contact_us.coffee'
            'src/javascripts/feedback.coffee'
          ]

    uglify:
      options:
        banner: '<%= banner %>\n'
      build:
        src: 'dist/application.js'
        dest: 'dist/application.js'

    # $ grunt watch
    watch:
      sass:
        files: 'src/stylesheets/*.scss'
        tasks: ['sass']
      coffee:
        files: 'src/javascripts/*.coffee'
        tasks: ['coffee']
      options:
        reload: true
        liveReload: true
        atBegin: true

    clean:
      build: ["public/*.*"],
      dist: ["dist/*.*"]

  # $ grunt build
  grunt.registerTask 'build', ["clean:build", "sass", "coffee"]

  # $ grunt dist
  grunt.registerTask 'dist', ->
    if grunt.file.defaultEncoding isnt 'utf8'
      grunt.fail.fatal("Your environments encoding is #{grunt.file.defaultEncoding} but must be 'utf8'")

    grunt.log.writeln grunt.config "internal.default.sv_base_url"
    # grunt.config "forDist", true
    # grunt.config "generateSourceMaps", false
    # grunt.task.run [
    #   "clean:dist"
    #   "sass"
    #   "coffee"
    #   "uglify"
    # ]

  environment = grunt.option('environment') or 'development'
  audience    = grunt.option('audience') or "internal"

  grunt.registerTask 'foo', ->
    grunt.log.writeln environment
    grunt.log.writeln audience
    grunt.log.writeln grunt.config "audience.#{audience}.production.sv_base_url"

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    coffee:
      compile:
        expand: true
        flatten: false
        cwd: 'src'
        src: '**/*.coffee'
        dest: 'dist/'
        ext: '.js'
        sourceMap: true
        sourceMapDir: 'maps'
    copy:
      assets:
        expand: true
        src: 'assets/**/*'
        dest: 'dist/'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  String.prototype.toTitleCase = ->
    @replace /\w\S*/g, (txt) -> (txt.charAt 0).toUpperCase() + (txt.substr 1).toLowerCase()
  grunt.registerTask 'manifest', 'Generates manifest.json for Chrome', () ->
    done = @async()
    pkg = require './package.json'
    manifest =
      name: (pkg.name.replace '-', ' ').toTitleCase().replace 'Classhub', 'ClassHub'
      description: pkg.description
      version: pkg.version
      manifest_version: 2
      app:
        background:
          scripts: [(pkg.main.split '/')[1]]
      icons:
        16: 'assets/16.png'
        128: 'assets/128.png'
    fs = require 'fs'
    path = require 'path'
    fs.writeFile (path.join __dirname, 'dist', 'manifest.json'), (JSON.stringify manifest, null, 2), (err) ->
      if err? then done false else done true

  grunt.registerTask 'default', ['coffee:compile', 'manifest', 'copy']

gulp = require 'gulp'
util = require 'gulp-util'
coffee = require 'gulp-coffee'
plumber = require 'gulp-plumber'
stylus = require 'gulp-stylus'
jade = require 'gulp-jade'
autoprefixer = require 'gulp-autoprefixer'
electron = require 'gulp-electron'
packageJson = require './dest/package.json'

PACKAGEJSON_FILE = './src/package.json'

gulp.task 'packagejson', ->
  gulp.src PACKAGEJSON_FILE
    .pipe gulp.dest './dest'

gulp.task 'watch-packagejson', ->
  gulp.watch PACKAGEJSON_FILE, ['packagejson']

JADE_FILES = './src/jade/**/*.jade'

gulp.task 'jade', ->
  gulp.src JADE_FILES
    .pipe jade {pretty: true}
    .pipe gulp.dest './dest'

gulp.task 'watch-jade', ->
  gulp.watch JADE_FILES, ['jade']

MAIN_FILE = './src/main.coffee'

gulp.task 'main-script', ->
  gulp.src MAIN_FILE
    .pipe plumber()
    .pipe coffee bare: true
    .on 'error', util.log
    .pipe gulp.dest './dest'

gulp.task 'watch-main-script', ->
  gulp.watch MAIN_FILE, ['main-script']

COFFEE_FILES = './src/coffee/**/*.coffee'

gulp.task 'coffee', ->
  gulp.src COFFEE_FILES
    .pipe plumber()
    .pipe coffee bare: true
    .on 'error', util.log
    .pipe gulp.dest './dest/js'

gulp.task 'watch-coffee', ->
  gulp.watch COFFEE_FILES, ['coffee']

STYLUS_FILES = './src/styl/**/*.styl'

gulp.task 'stylus', ->
  gulp.src STYLUS_FILES
    .pipe stylus {set: ['compress']}
    .pipe autoprefixer 'last 1 version'
    .pipe gulp.dest './dest/css'

gulp.task 'watch-stylus', ->
  gulp.watch STYLUS_FILES, ['stylus']

IMAGE_FILES = './src/images/**/*.{jpg,jpeg,png,gif}'

gulp.task 'images', ->
  gulp.src IMAGE_FILES
    .pipe gulp.dest './dest/images'

gulp.task 'watch-images', ->
  gulp.watch IMAGE_FILES, ['images']

gulp.task 'electron', ->
  gulp.src ''
    .pipe electron {
      src: './dest'
      packageJson: packageJson,
      release: './release'
      cache: './cache'
      version: 'v0.25.2'
      rebuild: true
      platforms: ['win32-ia32', 'darwin-x64']
    }
    .pipe gulp.dest ''

gulp.task 'watch', ['watch-packagejson', 'watch-main-script', 'watch-jade', 'watch-coffee', 'watch-stylus', 'watch-images']
gulp.task 'default', ['packagejson', 'main-script', 'jade', 'coffee', 'stylus', 'images']
gulp.task 'release', ['default', 'electron']

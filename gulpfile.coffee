gulp = require('gulp')
plumber = require('gulp-plumber')
coffee = require('gulp-coffee')
concat = require('gulp-concat')
uglify = require('gulp-uglify')
webserver = require('gulp-webserver')
webpack = require('gulp-webpack')
haml = require('gulp-haml')
less = require('gulp-less')

webpackConfig =
  entry: './src/coffee/main'
  output:
    filename: 'all.min.js'
  resolve:
    extensions: ['', '.js', '.coffee']
  module:
    loaders: [
      test: /\.coffee$/
      loader: 'coffee-loader'
    ]

gulp.task 'html', ->
  gulp.src('./src/html/index.haml')
    .pipe(haml())
    .pipe(gulp.dest('dist'))

gulp.task 'sounds', ->
  gulp.src('./src/sounds/pop.ogg')
    .pipe(gulp.dest('dist/sounds'))

gulp.task 'css', ->
  gulp.src('./src/stylesheets/*.less')
    .pipe(plumber())
    .pipe(less())
    .pipe(gulp.dest('dist/stylesheets'))

gulp.task 'webpack', ->
  gulp.src(webpackConfig.entry)
    .pipe(webpack(webpackConfig))
    .pipe(gulp.dest('dist/js'))

gulp.task 'watch', ->
  gulp.watch('./src/coffee/*.coffee', ['webpack'])
  gulp.watch('./src/html/*.haml', ['html'])

gulp.task 'webserver', ->
  gulp.src('./dist')
    .pipe(webserver
      host: 'localhost'
      livereload: true
    )

gulp.task 'default', ['html', 'sounds', 'css', 'webpack', 'watch', 'webserver']

templateCache     = require 'gulp-angular-templatecache'
gulp              = require 'gulp'
concat            = require 'gulp-concat'
jade              = require 'gulp-jade'


gulp.task "convertTemplates", [], ->
  gulp.src("src/views/templates/**/*.jade")
    .pipe jade({})
    .pipe templateCache(module: "ngSelect")
    .pipe concat('templates.js')
    .pipe gulp.dest('temp')

gulp.task "javascript:library:templates", ['convertTemplates', 'javascript:library:js'], ->
  gulp.src(["./public/library.js", "./temp/templates.js"])
    .pipe concat('library.js')
    .pipe gulp.dest('public')
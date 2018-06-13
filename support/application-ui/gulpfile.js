var gulp = require('gulp'),
    uglify = require('gulp-uglify'),
    less = require('gulp-less'),
    plumber = require('gulp-plumber'),
    browserSync = require('browser-sync'),
    reload = browserSync.reload,
    path = require('path');

// Uglyfies js on to /js/minjs
gulp.task('scripts', function(done){
    gulp.src('js/*.js')
        .pipe(plumber())
        .pipe(uglify())
        .pipe(gulp.dest("js/minjs"));
    done();
});

// Compiles less on to /css
gulp.task('less', function (done) {
    gulp.src('less/**/*.less')
        .pipe(plumber())
        .pipe(less({
            paths: [ path.join('node_modules'), path.join('node_modules/patternfly/node_modules') ],
            sourceMap: {
                //sourceMapRootpath: '../less' // This one for KIE files (Optional absolute or relative path to your LESS files)
                sourceMapRootpath: '/' // This one for PF files (Optional absolute or relative path to your LESS files)
            }

        }))
        .pipe(gulp.dest('css'))
        .pipe(reload({stream:true}));
    done();
});

// reload server
gulp.task('browser-sync', function(done) {
    browserSync({
        server: {
            baseDir: "./"
        }
    });
    done();
});

// Reload all Browsers
gulp.task('bs-reload', function (done) {
    browserSync.reload();
    done();
});

// watch for changes on files
gulp.task('watch', function(done){
    gulp.watch('js/*.js', gulp.series('scripts'));
    gulp.watch('less/*.less', gulp.series('less'));
    gulp.watch("*.html", gulp.series('bs-reload'));
    done();
});


//gulp.task('default', gulp.series('scripts', 'less', 'browser-sync', 'watch'));
gulp.task('default', gulp.series('scripts', 'less', 'browser-sync', 'watch'));

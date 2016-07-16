var gulp = require('gulp');
var gutil = require('gulp-util');
var concat = require('gulp-concat');
var del = require('del');
var runSequence = require('run-sequence');
var sass = require('gulp-sass');
var coffee = require('gulp-coffee');
var pug = require('gulp-pug');
var minifyJs = require('gulp-uglify')
var imagemin = require('gulp-imagemin');
var htmlmin = require('gulp-htmlmin');
var nodemon = require('gulp-nodemon');
var browserSync = require('browser-sync').create();

//-----------------
//SERVER-----------
//-----------------
//coffee -- server and routes
gulp.task('coffee:server', function() {
	gulp.src('./src/*.coffee')
		.pipe(coffee({bare: true}).on('error', gutil.log))
		.pipe(minifyJs())
		.pipe(gulp.dest('./dist/'))
});
//coffee -- routes
gulp.task('coffee:config', function() {
	gulp.src('./src/server/config/*.coffee')
		.pipe(coffee({bare: true}).on('error', gutil.log))
		.pipe(minifyJs())
		.pipe(gulp.dest('./dist/server/config/'))
});
//coffee -- models
gulp.task('coffee:models', function() {
	gulp.src('./src/server/models/*.coffee')
		.pipe(coffee({bare: true}).on('error', gutil.log))
		.pipe(minifyJs())
		.pipe(gulp.dest('./dist/server/models/'))
});

//-----------------
//CLIENT-----------
//-----------------
//sass
gulp.task('sass', function() {
	return gulp.src('./src/client/assets/styles/master.sass')
		.pipe(sass({outputStyle: 'compressed'}).on('error', sass.logError))
		.pipe(gulp.dest('./dist/client/assets/styles/'))
		.pipe(browserSync.reload({
			stream: true
		}))
});
gulp.task('coffee:ng-app', function() {
	return gulp.src('./src/client/js/**/*.coffee')
		.pipe(coffee({bare: true}).on('error', gutil.log))
		.pipe(minifyJs())
		.pipe(concat('app.min.js'))
		.pipe(gulp.dest('dist/client/js'))
		.pipe(browserSync.reload({
			stream: true
		}))
});

/*
//coffee -- angular app
gulp.task('coffee:ng-app', function() {
	gulp.src('./src/client/app.coffee')
		.pipe(coffee({bare: true}).on('error', gutil.log))
		.pipe(gulp.dest('./dist/client/'))
		.pipe(browserSync.reload({
			stream: true
		}))
});

//coffee -- angular controllers
gulp.task('coffee:ng-controllers', function() {
	gulp.src('./src/client/controllers/*.coffee')
		.pipe(coffee({bare: true}).on('error', gutil.log))
		.pipe(gulp.dest('./dist/client/controllers/'))
		.pipe(browserSync.reload({
			stream: true
		}))
});

//coffee -- angular services
gulp.task('coffee:ng-services', function() {
	gulp.src('./src/client/services/*.coffee')
		.pipe(coffee({bare: true}).on('error', gutil.log))
		.pipe(gulp.dest('./dist/client/services/'))
		.pipe(browserSync.reload({
			stream: true
		}))
});

//coffee -- angular directives
gulp.task('coffee:ng-directives', function() {
	gulp.src('./src/client/directives/*.coffee')
		.pipe(coffee({bare: true}).on('error', gutil.log))
		.pipe(gulp.dest('./dist/client/directives/'))
		.pipe(browserSync.reload({
			stream: true
		}))
});
*/
//pug -- angular index view
gulp.task('pug:ng-index', function buildHTML() {
	return gulp.src('./src/client/*.pug')
		.pipe(pug({}))
		.pipe(gulp.dest('./dist/client/'))
		.pipe(browserSync.reload({
			stream: true
		}))
});

//pug -- angular views
gulp.task('pug:ng-views', function buildHTML() {
	return gulp.src('./src/client/views/*.pug')
		.pipe(pug({}))
		.pipe(gulp.dest('./dist/client/views/'))
		.pipe(browserSync.reload({
			stream: true
		}))
});

//pug -- angular directive pug
gulp.task('pug:ng-directives', function buildHTML() {
	return gulp.src('./src/client/js/directives/*.pug')
		.pipe(pug({}))
		.pipe(gulp.dest('./dist/client/js/directives/'))
		.pipe(browserSync.reload({
			stream: true
		}))
});

//copy library over
gulp.task('copy:libs', function() {
	gulp.src('./src/client/assets/libs/*')
		.pipe(gulp.dest('./dist/client/assets/libs/'))
});

//copy fonts
gulp.task('copy:fonts', function() {
	gulp.src('./src/client/assets/fonts/*')
		.pipe(gulp.dest('./dist/client/assets/fonts'))
});

//copy images over --TEST
gulp.task('copy:images', function() {
	gulp.src('./src/client/assets/images/*')
		.pipe(gulp.dest('./dist/client/assets/images/'))
});

//clean dist
gulp.task('clean', function() {
	return del.sync('dist');
})

//watch files
gulp.task('watch', ['browserSync', 'build'], function() {
	gulp.watch('./src/client/assets/styles/*.sass', ['sass']);
	gulp.watch('./src/client/assets/styles/partials/*.sass', ['sass']);
	gulp.watch('./src/client/js/**/*.coffee', ['coffee:ng-app']);
	gulp.watch('./src/server/*.coffee', ['coffee:server']);
	gulp.watch('./src/client/*.pug', ['pug:ng-index']);
	gulp.watch('./src/client/views/*.pug', ['pug:ng-views']);
	gulp.watch('./src/client/views/partials/*.pug', ['pug:ng-views']);
	gulp.watch('./src/client/js/directives/*.pug', ['pug:ng-directives']);
});

//----------
//dev server
//----------
gulp.task('nodemon', function() {
	nodemon({
		script: './dist/server.js',
		ext: 'js',
		env: { 'NODE_ENV' : 'development' }
	}).on('restart', function() {
		console.log('Server Restarted!');
	})
});

//-------
//browser sync
//------
gulp.task('browserSync', ['nodemon'], function() {
	browserSync.init(null, {
		proxy: "http://localhost:8080",
		browser: ['google chrome'],
		port: 3000
	})
});

//---------------------
//build and serve tasks
//---------------------
//minify images -- for gulp serve or build not watching
gulp.task('minify:images', function() {
	gulp.src('./src/client/assets/images/*')
		.pipe(imagemin())
		.pipe(gulp.dest('./dist/client/assets/images/'))
});

//minify index html
gulp.task('minify:html-ngapp', function() {
	return gulp.src('./dist/client/index.html')
		.pipe(htmlmin({collapseWhitespace: true}))
		.pipe(gulp.dest('./dist/client/index.html'))
});

//minify html files
gulp.task('minify:html-views', function() {
	return gulp.src('./dist/client/views/*.html')
		.pipe(htmlmin({collapseWhitespace: true}))
		.pipe(gulp.dest('./dist/client/views/*.html'))
});

//----------
//gulp tasks
//----------
//defualt watch files (that includes building) and starting nodemon serve
gulp.task('default', ['watch']);

//build dev
gulp.task('build', function (callback) {
	runSequence('clean', [
		'sass',
		'coffee:ng-app',
		'coffee:server',
		'coffee:models',
		'coffee:config',
		'pug:ng-index',
		'pug:ng-views',
		'pug:ng-directives',
		'copy:libs',
		'copy:fonts',
		'copy:images'
	], callback
	)
});

//prod build
gulp.task('serve', function (callback) {
	runSequence('clean', [
		'sass',
		'coffee:ng-app',
		'coffee:server',
		'coffee:models',
		'coffee:config',
		'pug:ng-index',
		'pug:ng-views',
		'pug:ng-directives',
		'minify:images',
		'copy:libs',
		'copy:fonts',
		'minify:html-ngapp',
		'minify:html-views'
		//TODO prefix min and minify js and css
	], callback
	)
});
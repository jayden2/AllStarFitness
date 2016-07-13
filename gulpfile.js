var gulp = require('gulp');
var gutil = require('gulp-util');
var del = require('del');
var runSequence = require('run-sequence');
var coffee = require('gulp-coffee');
var nodemon = require('gulp-nodemon');

//coffee -- server
gulp.task('coffee:server', function() {
	gulp.src('./src/*.coffee')
		.pipe(coffee({bare: true}).on('error', gutil.log))
		.pipe(gulp.dest('./dist/'))
});
//coffee -- routes
gulp.task('coffee:config', function() {
	gulp.src('./src/config/*.coffee')
		.pipe(coffee({bare: true}).on('error', gutil.log))
		.pipe(gulp.dest('./dist/config/'))
});
//coffee -- models
gulp.task('coffee:models', function() {
	gulp.src('./src/models/*.coffee')
		.pipe(coffee({bare: true}).on('error', gutil.log))
		.pipe(gulp.dest('./dist/models/'))
});

//clean dist
gulp.task('clean', function() {
	return del.sync('dist');
})

//watch files
gulp.task('watch', ['build', 'nodemon'], function() {
	gulp.watch('./src/*.coffee', ['coffee:server']);
	gulp.watch('./src/config/*.coffee', ['coffee:config']);
	gulp.watch('./src/models/*.coffee', ['coffee:models']);
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

gulp.task('default', ['watch']);

//build dev
gulp.task('build', function (callback) {
	runSequence('clean', [
		'coffee:server',
		'coffee:config',
		'coffee:models'
	], callback
	)
});
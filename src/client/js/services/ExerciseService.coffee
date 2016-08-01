ExerciseService = ($http, $q, $window, $httpParamSerializerJQLike) ->
	
	##CREATE EXERCISE
	createExercise = (exercise, token) ->
		deferred = $q.defer()
		$http.post('/api/exercises/' + '?token=' + token,
			title: exercise.title
			description: exercise.description
			exercise.image
			def_set_start: exercise.def_set_start
			def_set_end: exercise.def_set_end
			def_rep_start: exercise.def_rep_start
			def_rep_end: exercise.def_rep_end
			date_created: exercise.date_created
			favourite: 0).success ((result) ->
			if result.success == true
				exerciseSave =
					success: result.success
					message: result.message
				deferred.resolve exerciseSave
				return
		), (error) ->
			deferred.reject error
			return
		deferred.promise

	#GET ALL EXERCISES
	getAllExercises = (token) ->
		deferred = $q.defer()
		exerciseSave = {}
		#push into object array
		$http.get('/api/exercises/' + '?token=' + token).success ((result) ->
			if result
				exerciseSave = result
				deferred.resolve exerciseSave
				return
			else
				exerciseSave =
					success: false
					message: 'Exercise not found!'
				deferred.resolve exerciseSave
				return
		), (error) ->
			console.log error
			deferred.reject error
			return
		deferred.promise

	#GET ONE EXERCISES
	getOneExercise = (id, token) ->
		deferred = $q.defer()
		exerciseSave = {}
		$http.get('/api/exercises/' + id + '?token=' + token).success ((result) ->
			if result
				exerciseSave =
					success: true
					id: result.id
					title: result.title
					description: result.description
					image: result.image
					def_set_start: result.def_set_start
					def_set_end: result.def_set_end
					def_rep_start: result.def_rep_start
					def_rep_end: result.def_rep_end
					date_created: result.date_created
					favourite: result.favourite
				deferred.resolve exerciseSave
				return
			else
				exerciseSave=
					success: false
					message: 'exercise not found!'
				deferred.resolve exerciseSave
				return
		), (error) ->
			console.log error
			deferred.reject error
			return
		deferred.promise

	##UPDATE EXERCISES
	updateExercise = (exercise, id, token) ->
		deferred = $q.defer()
		$http.put('/api/exercises/' + id + '?token=' + token,
			title: exercise.title
			description: exercise.description
			image: exercise.image
			def_set_start: exercise.def_set_start
			def_set_end: exercise.def_set_end
			def_rep_start: exercise.def_rep_start
			def_rep_end: exercise.def_rep_end
			favourite: exercise.favourite).success ((result) ->
			if result.success == true
				exerciseSave =
					success: result.success
					message: result.message
				deferred.resolve exerciseSave
				return
		), (error) ->
			deferred.reject error
			return
		deferred.promise

	##DELETE EXERCISE
	deleteExercise = (id, token) ->
		deferred = $q.defer()
		$http.delete('/api/exercises/' + id + '?token=' + token).success ((result) ->
			if result.success == true
				exerciseSave =
					success: result.success
					message: result.message
				deferred.resolve exerciseSave
				return
		), (error) ->
			deferred.reject error
			return
		deferred.promise

	##FAVOURITE EXERCISE
	favouriteExercise = (id, favourite, token) ->
		deferred = $q.defer()
		$http.put('/api/exercises/' + id + '/favourite/?token=' + token,
			favourite: favourite).success ((result) ->
			if result.success == true
				exerciseSave =
					success: result.success
					message: result.message
				deferred.resolve exerciseSave
				return
		), (error) ->
			deferred.reject error
			return
		deferred.promise

	##UPLOAD IMAGE
	uploadImage = (photo, token) ->
		fd = new FormData()
		fd.append('photo', photo)

		deferred = $q.defer()
		$http.post('http://localhost:3000/api/exercises/image/upload/' + '?token=' + token,
			fd,
			transformRequest: angular.identity
			headers: 'Content-Type': undefined).success ((result) ->
				deferred.resolve result
				return
		), (error) ->
			deferred.reject error
			return
		deferred.promise


	##DELETE IMAGE
	deleteImage = (image, token) ->
		deferred = $q.defer()
		$http.post('http://localhost:3000/api/exercises/image/delete/' + '?token=' + token,
			image: image).success ((result) ->
				deferred.resolve result
				return
		), (error) ->
			deferred.reject error
			return
		deferred.promise
		

	{
		createExercise: createExercise
		getAllExercises: getAllExercises
		getOneExercise: getOneExercise
		updateExercise: updateExercise
		deleteExercise: deleteExercise
		favouriteExercise: favouriteExercise
		uploadImage: uploadImage
		deleteImage: deleteImage
	}

angular.module('AllStarFitness')
	.factory 'ExerciseService', [
		'$http'
		'$q'
		'$window'
		'$httpParamSerializerJQLike'
		ExerciseService
	]
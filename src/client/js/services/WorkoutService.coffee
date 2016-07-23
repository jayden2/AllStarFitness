WorkoutService = ($http, $q, $window, $httpParamSerializerJQLike) ->
	
	##CREATE WORKOUT
	createWorkout = (workout, token) ->
		deferred = $q.defer()
		$http.post('/api/workouts/' + '?token=' + token,
			title: workout.title
			description: workout.description
			image: workout.image
			def_set_start: workout.def_set_start
			def_set_end: workout.def_set_end
			def_rep_start: workout.def_rep_start
			def_rep_end: workout.def_rep_end
			date_created: workout.date_created
			favourite: workout.favourite).success ((result) ->
			if result.success == true
				workoutSave =
					success: result.success
					message: result.message
				deferred.resolve workoutSave
				return
		), (error) ->
			deferred.reject error
			return
		deferred.promise

	#GET ALL WORKOUTS
	getAllWorkouts = (token) ->
		deferred = $q.defer()
		workoutSave = {}
		#push into object array
		$http.get('/api/workouts/' + '?token=' + token).success ((result) ->
			if result
				workoutSave =
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
				deferred.resolve workoutSave
				return
			else
				workoutSave =
					success: false
					message: 'Workout not found!'
				deferred.resolve workoutSave
				return
		), (error) ->
			console.log error
			deferred.reject error
			return
		deferred.promise

	#GET ONE WORKOUTS
	getOneWorkout = (id, token) ->
		deferred = $q.defer()
		workoutSave = {}
		$http.get('/api/workouts/' + id + '?token=' + token).success ((result) ->
			if result
				workoutSave =
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
				deferred.resolve workoutSave
				return
			else
				workoutSave=
					success: false
					message: 'Workout not found!'
				deferred.resolve workoutSave
				return
		), (error) ->
			console.log error
			deferred.reject error
			return
		deferred.promise

	##UPDATE WORKOUT
	updateWorkout = (workout, id, token) ->
		deferred = $q.defer()
		$http.put('/api/workouts/' + id + '?token=' + token,
			title: workout.title
			description: workout.description
			image: workout.image
			def_set_start: workout.def_set_start
			def_set_end: workout.def_set_end
			def_rep_start: workout.def_rep_start
			def_rep_end: workout.def_rep_end
			favourite: workout.favourite).success ((result) ->
			if result.success == true
				workoutSave =
					success: result.success
					message: result.message
				deferred.resolve workoutSave
				return
		), (error) ->
			deferred.reject error
			return
		deferred.promise

		##DELETE WORKOUT
		deleteWorkout = (id, token) ->
			deferred = $q.defer()
			$http.delete('/api/documents/' + id + '?token=' + token).success ((result) ->
				if result.success == true
					workoutSave =
						success: result.success
						message: result.message
					deferred.resolve workoutSave
					return
			), (error) ->
				deferred.reject error
				return
			deferred.promise

angular.module('AllStarFitness')
	.factory 'WorkoutService', [
		'$http'
		'$q'
		'$window'
		'$httpParamSerializerJQLike'
		WorkoutService
	]
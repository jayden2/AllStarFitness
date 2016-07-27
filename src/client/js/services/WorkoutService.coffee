WorkoutService = ($http, $q, $window, $httpParamSerializerJQLike) ->
	
	##CREATE WORKOUTS
	createWorkout = (workout, token) ->
		deferred = $q.defer()
		$http.post('/api/workouts/' + '?token=' + token,
			title: workout.title
			collection: workout.collection
			user_id: workout.user_id
			template: workout.template
			date_created: workout.date_created).success ((result) ->
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
		$http.get('/api/workouts/' + '?token=' + token).success ((result) ->
			if result
				workoutSave = result
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
					id: result.id
					title: result.title
					collection: result.collection
					user_id: result.user_id
					template: result.template
					date_created: result.date_created
					date_updated: result.date_updated
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

	##UPDATE WORKOUTS
	updateWorkout = (workout, id, token) ->
		deferred = $q.defer()
		$http.put('/api/workouts/' + id + '?token=' + token,
			title: workout.title
			collection: workout.collection
			user_id: workout.user_id
			template: workout.template).success ((result) ->
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
			$http.delete('/api/workouts/' + id + '?token=' + token).success ((result) ->
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
		

	{
		createWorkout: createWorkout
		getAllWorkouts: getAllWorkouts
		getOneWorkout: getOneWorkout
		updateWorkout: updateWorkout
		deleteWorkout: deleteWorkout
	}

angular.module('AllStarFitness')
	.factory 'WorkoutService', [
		'$http'
		'$q'
		'$window'
		'$httpParamSerializerJQLike'
		WorkoutService
	]
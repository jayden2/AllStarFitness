PublishController = ($scope, $routeParams, LoginService, WorkoutService, ExerciseService) ->

	#scope variables
	$scope.loading = false
	$scope.workout = { }
	$scope.exercises = { }
	$scope.collection = []
	currentUser = LoginService.getUserInfo()


	#get all exercises to fill dropdown selection
	getAllExercises = ->
		$scope.loading = true
		ExerciseService.getAllExercises(currentUser.token).then ((result) ->
			$scope.loading = false
			$scope.exercises = result
		), (error) ->
			console.log error
			$scope.loading = false
			return
		return

	#get workout from id
	getWorkout = ->
		if $scope.loading == false
			$scope.loading = true
			WorkoutService.getOneWorkout($routeParams.id, currentUser.token).then ((result) ->
				$scope.workout = result[0]
				$scope.loading = false
				getWorkoutCollection()
				maleOrFemale()
			), (error) ->
				console.log error
				$scope.loading = false
				return
		return

	getWorkoutCollection = ->
		if $scope.loading == false
			$scope.loading = true
			ExerciseService.getMultipleExercises($scope.workout.collection, currentUser.token).then ((result) ->
				sortCollection(result)
				$scope.loading = false
			), (error) ->
				console.log error
				$scope.loading = false
				return
		return

	#sort array collection, get the get data, iterate through it and assemble
	sortCollection = (unsortedcollection) ->
		collectionIds = $scope.workout.collection.split(',')
		i = 0	
		while i < Object.keys(unsortedcollection).length
			angular.forEach unsortedcollection, (value, key) ->
				if value.id.toString() == collectionIds[i].toString()
					$scope.collection.push(value)
					return
			i++
		return

	maleOrFemale = ->
		if $scope.workout.gender == 'f'
			$('.exercise-table').addClass('fForm')
		else
			$('.exercise-table').addClass('mForm')
		return


	getWorkout()
	getAllExercises()
	return

angular.module('AllStarFitness')
	.controller 'PublishController', [
		'$scope'
		'$routeParams'
		'LoginService'
		'WorkoutService'
		'ExerciseService'
		PublishController
	]
publishController = ($scope, $routeParams, LoginService, WorkoutService, ExerciseService) ->

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
				checkCollectionLength()
				$scope.loading = false
			), (error) ->
				console.log error
				$scope.loading = false
				return
		return

	#sort array collection, get the get data, iterate through it and assemble
	sortCollection = (unsortedcollection) ->
		collectionIds = $scope.workout.collection.split(', ')
		i = 0	
		while i < Object.keys(unsortedcollection).length
			angular.forEach unsortedcollection, (value, key) ->
				if value.id.toString() == collectionIds[i].toString()
					$scope.collection.push(value)
					return
			i++
		return

	#adjust styles in exercise title list
	checkCollectionLength = ->
		if Object.keys($scope.collection).length % 2 == 0
			$('.workout-box').removeClass('workout-box-odd')
			$('.workout-box').addClass('workout-box-even')
		else
			$('.workout-box').removeClass('workout-box-even')
			$('.workout-box').addClass('workout-box-odd')
		return

	getWorkout()
	getAllExercises()
	return

angular.module('AllStarFitness')
	.controller 'publishController', [
		'$scope'
		'$routeParams'
		'LoginService'
		'WorkoutService'
		'ExerciseService'
		publishController
	]
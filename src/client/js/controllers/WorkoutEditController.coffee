WorkoutEditController = ($scope, $filter, $routeParams, LoginService, WorkoutService, ExerciseService) ->

	$scope.loading = false
	$scope.workoutChanged = false
	$scope.workout = { }
	$scope.exercises = { }
	$scope.collection = { }
	$scope.search = { }
	currentUser = LoginService.getUserInfo()


	#push selected exercise to collection
	$scope.addExercise = (selected) ->
		found = false
		$('.alert').remove()
		angular.forEach $scope.collection, (value, key) ->
			if value.title == selected.title
				found = true
				error_message = "<div class='alert alert-danger alert-dismissible' role='alert'>" + 'Cannot add `' + selected.title + '` exercise as it already exists!' + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button></div>"
				$('.add-exercise:first-child').prepend(error_message)
		if !found
			$scope.workoutChanged = true
			$scope.collection.push(selected)
			$scope.selected = null
			$('.add-exercise > input').val('')
		return

	$scope.saveWorkout = ->
		console.log 'saving workout'
		console.log $scope.collection
		return

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
				$scope.collection = result
				$scope.loading = false
				console.log $scope.collection
			), (error) ->
				console.log error
				$scope.loading = false
				return
		return



	getWorkout()
	getAllExercises()
	return

angular.module('AllStarFitness')
	.controller 'WorkoutEditController', [
		'$scope'
		'$filter'
		'$routeParams'
		'LoginService'
		'WorkoutService'
		'ExerciseService'
		WorkoutEditController
	]
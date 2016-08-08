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
		if $scope.collection != null
			angular.forEach $scope.collection, (value, key) ->
				if value.id == selected.id
					found = true
					error_message = "<div class='alert alert-danger alert-dismissible' role='alert'>" + 'Cannot add `' + selected.title + '` exercise as it already exists!' + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button></div>"
					$('.add-exercise:first-child').prepend(error_message)
			if !found
				$scope.workoutChanged = true
				$scope.collection.push(selected)
				$scope.selected = null
				$('.add-exercise > input').val('')
			return

	#remove exercise from collection
	$scope.removeExercise = (selected) ->
		angular.forEach $scope.collection, (value, key) ->
			if value.id == selected.id
				$scope.collection.splice(key, 1)
				$scope.workoutChanged = true


	$scope.saveWorkout = ->
		console.log 'saving workout'
		console.log $scope.collection
		collectionHolder = ""
		commaRound = false

		if $scope.collection.length
			angular.forEach $scope.collection, (value, key) ->
				if commaRound then collectionHolder += ", " + value.id else collectionHolder += value.id
				commaRound = true
		else
			collectionHolder = "0"

		WorkoutService.updateCollectionWorkout($scope.workout.id, collectionHolder, currentUser.token).then ((result) ->
				errOrSaveResult(result.success, result.message)
				$scope.loading = false
				$scope.workoutChanged = false
			), (error) ->
				console.log error
				$scope.loading = false
				return
		
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

	$scope.$watch 'collection', ->
		console.log 'edited'

	#push error or success
	errOrSaveResult = (type, message) ->
		$('.alert').remove()
		if type == true
			sendMessage = "<div class='alert alert-success alert-dismissible' role='alert'>" + message + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button></div>"
		else
			sendMessage = "<div class='alert alert-danger alert-dismissible' role='alert'>" + message + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button></div>"
		$('.savepub-exercise').prepend(sendMessage)
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
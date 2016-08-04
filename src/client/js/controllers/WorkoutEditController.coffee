WorkoutEditController = ($scope, $filter, $routeParams, LoginService, WorkoutService, ExerciseService) ->

	$scope.loading = false
	$scope.workout = { }
	$scope.collection = { }
	$scope.search = { }
	currentUser = LoginService.getUserInfo()

	#get workout from id
	getWorkout = ->
		if $scope.loading == false
			$scope.loading = true
			WorkoutService.getOneWorkout($routeParams.id, currentUser.token).then ((result) ->
				$scope.workout = result[0]
				$scope.loading = false
				console.log $scope.workout
				getWorkoutCollection()
			), (error) ->
				console.log error
				$scope.loading = false
				return
		return

	getWorkoutCollection = ->
		if $scope.loading == false
			$scope.loading = true
			console.log $scope.workout.collection
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
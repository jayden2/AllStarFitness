WorkoutController = ($scope, $filter, $uibModal, LoginService, WorkoutService) ->

	#define workouts
	$scope.loading = false
	$scope.resultAmount = false
	$scope.search = { }
	currentUser = LoginService.getUserInfo()
	$scope.workouts = {}

	#get all users from service to fill table
	$scope.getWorkouts = (continueLoading) ->
		if $scope.loading == false || continueLoading == true
			$scope.loading = true
			WorkoutService.getAllWorkouts(currentUser.token).then ((result) ->
				$scope.workouts = result
				$scope.loading = false
			), (error) ->
				console.log error
				$scope.loading = false
				return
		return

	#search and filter workouts from search
	$scope.filteredWorkouts = ->
		$scope.resultAmount = false
		array = []
		for key of $scope.workouts
			$scope.resultAmount = true
			`key = key`
			array.push $scope.workouts[key]
		return $filter('filter') array, $scope.search.query

	#call service to make item a template
	$scope.template = (id, temp) ->
		$scope.loading = true
		if temp == 1 then toTemp = 0 else toTemp = 1
		WorkoutService.templateWorkout(id, toTemp, currentUser.token).then ((result) ->
			$scope.workouts = result
			$scope.getWorkouts(true)
		), (error) ->
			console.log error
			$scope.loading = false
			return

	$scope.getWorkouts(false)
	return

angular.module('AllStarFitness')
	.controller 'WorkoutController', [
		'$scope'
		'$filter'
		'$uibModal'
		'LoginService'
		'WorkoutService'
		WorkoutController
	]
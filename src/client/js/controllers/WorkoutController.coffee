WorkoutController = ($scope, $filter, $uibModal, LoginService, WorkoutService) ->

	#define workouts
	$scope.loading = false
	$scope.resultAmount = false
	$scope.search = { }
	currentUser = LoginService.getUserInfo()
	$scope.workouts = {}

	#get all users from service to fill table
	$scope.getWorkouts = ->
		if $scope.loading == false
			$scope.loading = true
			UserService.getAllWorkouts(currentUser.token).then ((result) ->
				$scope.workouts = result
				$scope.loading = false
			), (error) ->
				console.log error
				$scope.loading = false
				return
		return

	#search and filter workouts from search
	$scope.filteredUsers = ->
		$scope.resultAmount = false
		array = []
		for key of $scope.workouts
			$scope.resultAmount = true
			`key = key`
			array.push $scope.workouts[key]
		return $filter('filter') array, $scope.search.query


	$scope.getWorkouts()
	return

angular.module('AllStarFitness')
	.controller 'WorkoutController', [
		'$scope'
		'$scope'
		'$filter'
		'$uibModal'
		'LoginService'
		'WorkoutService'
		WorkoutController
	]
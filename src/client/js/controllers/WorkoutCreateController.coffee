WorkoutCreateController = ($scope, $filter, LoginService, WorkoutService, ExerciseService, UserService) ->

	#define variables
	$scope.loading = false
	$scope.users = { }
	$scope.search = { }
	$scope.workout = { }
	currentUser = LoginService.getUserInfo()

	#get all users from service to fill table
	getUsers = ->
		if $scope.loading == false
			$scope.loading = true
			UserService.getAllUsers(currentUser.token).then ((result) ->
				$scope.users = result
				$scope.loading = false
			), (error) ->
				console.log error
				$scope.loading = false
				return
		return

	getUsers()
	return

angular.module('AllStarFitness')
	.controller 'WorkoutCreateController', [
		'$scope'
		'$filter'
		'LoginService'
		'WorkoutService'
		'ExerciseService'
		'UserService'
		WorkoutCreateController
	]
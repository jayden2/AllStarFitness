WorkoutModalController = ($scope, $uibModalInstance, WorkoutService, LoginService, type, workout) ->
	
	#ititialise variables
	$scope.type = type
	savedWorkout = angular.copy(workout)
	$scope.workout = workout
	$scope.loading = false
	currentUser = LoginService.getUserInfo()

	return

angular.module('AllStarFitness')
	.controller 'WorkoutModalController', [
		'$scope'
		'$uibModalInstance'
		'WorkoutService'
		'LoginService'
		'type'
		'workout'
		WorkoutModalController
	]
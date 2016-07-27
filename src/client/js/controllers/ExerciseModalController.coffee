ExerciseModalController = ($scope, $uibModalInstance, ExerciseService, LoginService, type, exercise) ->
	
	#ititialise variables
	$scope.type = type
	savedExercise = angular.copy(exercise)
	$scope.exercise = exercise
	$scope.loading = false
	currentUser = LoginService.getUserInfo()

	return

angular.module('AllStarFitness')
	.controller 'ExerciseModalController', [
		'$scope'
		'$uibModalInstance'
		'ExerciseService'
		'LoginService'
		'type'
		'exercise'
		ExerciseModalController
	]
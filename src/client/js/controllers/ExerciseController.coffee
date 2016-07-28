ExerciseController = ($scope, $filter, $uibModal, LoginService, ExerciseService) ->
	
	#define users
	$scope.loading = false
	$scope.resultAmount = false
	$scope.search = { }
	currentUser = LoginService.getUserInfo()
	$scope.exercises = {}

	#get all exercises from service to fill table
	$scope.getExercises = ->
		if $scope.loading == false
			$scope.loading = true
			ExerciseService.getAllExercises(currentUser.token).then ((result) ->
				$scope.exercises = result
				$scope.loading = false
			), (error) ->
				console.log error
				$scope.loading = false
				return
		return

	#search and filter users from search
	$scope.filteredExercises = ->
		$scope.resultAmount = false
		array = []
		for key of $scope.exercises
			$scope.resultAmount = true
			`key = key`
			array.push $scope.exercises[key]
		return $filter('filter') array, $scope.search.query

	$scope.getExercises()
	return

angular.module('AllStarFitness')
	.controller 'ExerciseController', [
		'$scope'
		'$filter'
		'$uibModal'
		'LoginService'
		'ExerciseService'
		ExerciseController
	]
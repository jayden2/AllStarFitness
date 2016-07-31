ExerciseController = ($scope, $filter, $uibModal, LoginService, ExerciseService) ->
	
	#define users
	$scope.loading = false
	$scope.resultAmount = false
	$scope.search = { }
	currentUser = LoginService.getUserInfo()
	$scope.exercises = {}

	#get all exercises from service to fill table
	$scope.getExercises = (continueLoading) ->
		if $scope.loading == false || continueLoading == true
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

	$scope.favourite = (id, fav) ->
		$scope.loading = true
		if fav == 1 then toFav = 0 else	toFav = 1
		ExerciseService.favouriteExercise(id, toFav, currentUser.token).then ((result) ->
			$scope.exercises = result
			$scope.getExercises(true)
		), (error) ->
			console.log error
			$scope.loading = false
			return

	$scope.openModal = (typeModal, exercise) ->
		modalInstance = $uibModal.open(
			animation: true
			templateUrl: '/js/directives/modal-exercise.html'
			controller: 'ExerciseModalController'
			resolve:
				type: ->
					typeModal
				exercise: ->
					exercise
		)
		modalInstance.result.then ((formData) ->
			if formData == 'postupdel'
				$scope.getExercises(false)
		)

	$scope.getExercises(false)
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
ExerciseController = ($scope, $filter, $uibModal, LoginService, ExerciseService) ->
	
	#define users
	$scope.loading = false
	$scope.resultAmount = false
	$scope.search = { }
	currentUser = LoginService.getUserInfo()
	$scope.exercises = {}
	$scope.filterExercise = 'orig'

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
	$scope.filterDupe = (dupe) ->
		console.log dupe
		if dupe == 'all'
			$('.filter-drop').html $(this).text() + '<span>Show All </span>' + ' <span class="caret"></span>'
			$scope.filterExercise = 'all'
			$scope.filteredExercises()
		if dupe == 'favourite'
			$('.filter-drop').html $(this).text() + '<span>Show Favourites </span>' + ' <span class="caret"></span>'
			$scope.filterExercise = 'favourite'
			$scope.filteredExercises()
		else
			$('.filter-drop').html $(this).text() + '<span>Show Original </span>' + ' <span class="caret"></span>'
			$scope.filterExercise = 'orig'
			$scope.filteredExercises()
		return

	#search and filter users from search
	$scope.filteredExercises = ->
		$scope.resultAmount = false
		array = []
		for key of $scope.exercises
			$scope.resultAmount = true
			`key = key`
			if ($scope.filterExercise == 'all')
				array.push $scope.exercises[key]
			else if ($scope.filterExercise == 'favourite')
				if ($scope.exercises[key].favourite == 1)
					array.push $scope.exercises[key]
			else
				if ($scope.exercises[key].duplicated == 0)
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
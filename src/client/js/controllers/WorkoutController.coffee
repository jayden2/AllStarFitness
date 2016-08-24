WorkoutController = ($scope, $filter, $location, $uibModal, $document, LoginService, WorkoutService) ->

	#define workouts
	$scope.loading = false
	$scope.resultAmount = false
	$scope.search = { }
	$scope.filterWorkout = 'all'
	currentUser = LoginService.getUserInfo()
	$scope.workouts = {}

	#get all workout from service to fill table
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

	#filter template and all
	$scope.filterTemp = (temp) ->
		if temp == 'all'
			$('.filter-drop').html $(this).text() + '<span>Show All </span>' + ' <span class="caret"></span>'
			$scope.filterWorkout = 'all'
			$scope.filteredWorkouts()
		else
			$('.filter-drop').html $(this).text() + '<span>Show Templates </span>' + ' <span class="caret"></span>'
			$scope.filterWorkout = 'temp'
			$scope.filteredWorkouts()
		return

	#search and filter workouts from search
	$scope.filteredWorkouts = ->
		$scope.resultAmount = false
		array = []
		for key of $scope.workouts
			$scope.resultAmount = true
			`key = key`
			if ($scope.filterWorkout == 'temp')
				if ($scope.workouts[key].template == 1)
					array.push $scope.workouts[key]
			else
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

	$scope.countCollection = (collection) ->
		if !collection
			return numOf
		else
			return numOf = collection.split(/,/).length

	$scope.openModal = (typeModal, workout) ->
		modalInstance = $uibModal.open(
			templateUrl: '/js/directives/modal-workout.html'
			controller: 'WorkoutModalController'
			resolve:
				type: ->
					typeModal
				workout: ->
					workout
		)
		modalInstance.result.then ((formData) ->
			if formData == 'postupdel'
				$scope.getWorkouts()
		)
		return

	#create edit or publish location path -- edit or publish with id
	$scope.editPublishWorkout = (type, workout) ->
		if type == 'edit'
			$location.path '/dashboard/workouts/edit/' + workout.id
		else
			$location.path '/dashboard/publish/' + workout.id

	$scope.getWorkouts(false)
	return

angular.module('AllStarFitness')
	.controller 'WorkoutController', [
		'$scope'
		'$filter'
		'$location'
		'$uibModal'
		'$document'
		'LoginService'
		'WorkoutService'
		WorkoutController
	]
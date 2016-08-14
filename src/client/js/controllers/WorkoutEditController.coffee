WorkoutEditController = ($scope, $filter, $routeParams, $uibModal, $location, LoginService, WorkoutService, ExerciseService) ->

	$scope.loading = false
	$scope.workoutChanged = false
	$scope.workout = { }
	$scope.exercises = { }
	$scope.collection = []
	$scope.search = { }
	currentUser = LoginService.getUserInfo()

	$scope.sortableOptions =
		update: (e, ui) ->
			$scope.workoutChanged = true
		axis: 'y'

	#push selected exercise to collection
	$scope.addExercise = (selected) ->
		found = false
		$('.alert').remove()
		if $scope.collection != null
			angular.forEach $scope.collection, (value, key) ->
				if value.id == selected.id
					found = true
					error_message = "<div class='alert alert-danger alert-dismissible' role='alert'>" + selected.title + ' is already in the workout!' + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button></div>"
					$('.add-exercise:first-child').prepend(error_message)
			if !found
				$scope.workoutChanged = true
				$scope.collection.push(selected)
				$scope.selected = null
				$('.add-exercise > input').val('')
				checkCollectionLength()
			return
		return

	#remove exercise from collection
	$scope.removeExercise = (selected) ->
		angular.forEach $scope.collection, (value, key) ->
			if value.id == selected.id
				$scope.collection.splice(key, 1)
				$scope.workoutChanged = true

		checkCollectionLength()
		return

	$scope.duplicateExercise = (item) ->
		if $scope.loading == false
			$scope.loading = true
			#state that the item is a duplicated over original
			item.duplicated = 1
			ExerciseService.createExercise(item, currentUser.token).then ((result) ->
				$scope.loading = false
				duplicateExerciseBody(result.return_id)
			), (error) ->
				console.log error
				$scope.loading = false
				return
		duplicateExerciseBody = (id) ->
			newExercise = {
				id: id
				title: item.title
				description: item.description
				image: item.image
				duplicated: 1
				def_set_start: item.def_set_start
				def_set_end: item.def_set_end
				def_rep_start: item.def_rep_start
				def_rep_end: item.def_rep_end
				date_created: item.date_created
				favourite: 0
			}
			$scope.collection.push(newExercise)
			return
		return

	$scope.editExercise = (typeModal, exercise) ->
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
				errOrSaveResult(true, "successfully edited exercise!")
		)
		return

	$scope.removeWorkout = ->
		if $scope.loading == false
			$scope.loading = true
			WorkoutService.deleteWorkout($scope.workout.id, currentUser.token).then ((result) ->
					$scope.loading = false
					$location.path '/dashboard/workouts'
				), (error) ->
					console.log error
					$scope.loading = false
					return
		return

	$scope.saveWorkout = ->
		collectionHolder = ""
		commaRound = false

		#check if there if length in collection so that it iterates over something that exists
		if $scope.collection.length
			angular.forEach $scope.collection, (value, key) ->
				if commaRound then collectionHolder += ", " + value.id else collectionHolder += value.id
				commaRound = true
		else
			collectionHolder = "0"

		WorkoutService.updateCollectionWorkout($scope.workout.id, collectionHolder, currentUser.token).then ((result) ->
				errOrSaveResult(result.success, result.message)
				$scope.loading = false
				$scope.workoutChanged = false
			), (error) ->
				console.log error
				$scope.loading = false
				return
		
		return

	#get all exercises to fill dropdown selection
	getAllExercises = ->
		$scope.loading = true
		ExerciseService.getAllExercises(currentUser.token).then ((result) ->
			$scope.loading = false
			$scope.exercises = result
		), (error) ->
			console.log error
			$scope.loading = false
			return
		return

	#get workout from id
	getWorkout = ->
		if $scope.loading == false
			$scope.loading = true
			WorkoutService.getOneWorkout($routeParams.id, currentUser.token).then ((result) ->
				$scope.workout = result[0]
				$scope.loading = false
				getWorkoutCollection()
			), (error) ->
				console.log error
				$scope.loading = false
				return
		return

	getWorkoutCollection = ->
		if $scope.loading == false
			$scope.loading = true
			ExerciseService.getMultipleExercises($scope.workout.collection, currentUser.token).then ((result) ->
				sortCollection(result)
				checkCollectionLength()
				$scope.loading = false
			), (error) ->
				console.log error
				$scope.loading = false
				return
		return

	#sort array collection, get the get data, iterate through it and assemble
	sortCollection = (unsortedcollection) ->
		collectionIds = $scope.workout.collection.replace(" ", "").split(',')
		i = 0	
		while i < Object.keys(unsortedcollection).length
			angular.forEach unsortedcollection, (value, key) ->
				if value.id.toString() == collectionIds[i].toString()
					$scope.collection.push(value)
					return
			i++
		return

	#adjust styles in exercise title list
	checkCollectionLength = ->
		if Object.keys($scope.collection).length % 2 == 0
			$('.workout-box').removeClass('workout-box-odd')
			$('.workout-box').addClass('workout-box-even')
		else
			$('.workout-box').removeClass('workout-box-even')
			$('.workout-box').addClass('workout-box-odd')
		return

	#push error or success
	errOrSaveResult = (type, message) ->
		$('.alert').remove()
		if type == true
			sendMessage = "<div class='alert alert-success alert-dismissible' role='alert'>" + message + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button></div>"
		else
			sendMessage = "<div class='alert alert-danger alert-dismissible' role='alert'>" + message + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button></div>"
		$('.savepub-exercise').prepend(sendMessage)
		return

	getWorkout()
	getAllExercises()
	return

angular.module('AllStarFitness')
	.controller 'WorkoutEditController', [
		'$scope'
		'$filter'
		'$routeParams'
		'$uibModal'
		'$location'
		'LoginService'
		'WorkoutService'
		'ExerciseService'
		WorkoutEditController
	]
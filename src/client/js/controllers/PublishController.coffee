PublishController = ($scope, $routeParams, LoginService, WorkoutService, ExerciseService) ->

	#scope variables
	$scope.loading = false
	$scope.workout = { }
	$scope.exercises = { }
	$scope.collection = []
	currentUser = LoginService.getUserInfo()


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
				colourChoice()
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
				$scope.loading = false
			), (error) ->
				console.log error
				$scope.loading = false
				return
		return

	#sort array collection, get the get data, iterate through it and assemble
	sortCollection = (unsortedcollection) ->
		collectionIds = $scope.workout.collection.split(',')
		i = 0	
		while i < Object.keys(unsortedcollection).length
			angular.forEach unsortedcollection, (value, key) ->
				if value.id.toString() == collectionIds[i].toString()
					$scope.collection.push(value)
					return
			i++
		return

	#colour case to change colour theme
	colourChoice = ->
		switch $scope.workout.colour
			when 'green' then $('.publish-pdf').addClass('form-pdf-green')
			when 'red' then $('.publish-pdf').addClass('form-pdf-red')
			when 'purple' then $('.publish-pdf').addClass('form-pdf-purple')
			when 'orange' then $('.publish-pdf').addClass('form-pdf-orange')
			when 'pink' then $('.publish-pdf').addClass('form-pdf-pink')
			when 'yellow' then $('.publish-pdf').addClass('form-pdf-yell')
			when 'black' then $('.publish-pdf').addClass('form-pdf-bla')
			when 'blue' then $('.publish-pdf').addClass('form-pdf-bloop')
			else $('.publish-pdf').addClass('form-blue')
		return


	getWorkout()
	getAllExercises()
	return

angular.module('AllStarFitness')
	.controller 'PublishController', [
		'$scope'
		'$routeParams'
		'LoginService'
		'WorkoutService'
		'ExerciseService'
		PublishController
	]
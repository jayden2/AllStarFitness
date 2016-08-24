WorkoutModalController = ($scope, $uibModalInstance, WorkoutService, LoginService, UserService, type, workout) ->
	
	#ititialise variables
	$scope.users = { }
	$scope.search = { }
	$scope.workout = workout
	savedWorkout = angular.copy(workout)
	$scope.loading = false
	currentUser = LoginService.getUserInfo()

	#title of modal
	chooseModalType = ->
		if type == "create"
			$scope.title = "Create Workout"
			$scope.buttonSave = "Create Workout"
			$scope.buttonDelete = false
			$scope.workout.description = ""
		else
			$scope.title = "Edit Workout"
			$scope.buttonSave = "Save Workout"
			$scope.buttonDelete = true
			$scope.selected = {
				id: $scope.workout.id
				first_name: $scope.workout.first_name
				last_name: $scope.workout.last_name
			}

	$scope.confirm = ->
		#check if title is empty
		if isNullOrEmptyOrUndefined($scope.workout.title)
			formError("Title is empty")
			return
		#check if user is empty
		if isNullOrEmptyOrUndefined($scope.selected)
			formError("No user selected")
			return
		else
			$scope.workout.user_id = $scope.selected.id

		if isNullOrEmptyOrUndefined($scope.workout.collection)
			$scope.workout.collection = 0

		if !$scope.workout.collection.toString().match /^[0-9, ]*$/
			formError("Exercise id collection has been inputted incorrectly")
			return
		if type == 'create'
			postWorkout()
		else
			updateWorkout()
		return

	$scope.cancel = ->
		$scope.workout.title = savedWorkout.title
		$scope.workout.description = savedWorkout.description
		$scope.workout.collection = savedWorkout.collection
		$uibModalInstance.dismiss('cancel')
		return

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

	postWorkout = ->
		if $scope.loading == false
			$scope.loading = true
			WorkoutService.createWorkout($scope.workout, currentUser.token).then ((result) ->
				$scope.workout = result
				$scope.loading = false
				$uibModalInstance.close('postupdel')
			), (error) ->
				console.log error
				$scope.loading = false
				$uibModalInstance.close('postupdel')
				return
		return

	updateWorkout = ->
		if $scope.loading == false
			$scope.loading = true
			WorkoutService.updateWorkout($scope.workout, $scope.workout.id, currentUser.token).then ((result) ->
				$scope.workout = result
				$scope.loading = false
				$uibModalInstance.close('postupdel')
			), (error) ->
				console.log error
				$scope.loading = false
				$uibModalInstance.close('postupdel')
				return
		return

	#display error on form if there is an error
	formError = (errorText) ->
		$('.alert').remove()
		error_message = "<div class='alert alert-danger alert-dismissible' role='alert'>" + errorText + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button></div>"
		$('form').prepend(error_message)

	#validate form
	isNullOrEmptyOrUndefined = (value) ->
		!value

	chooseModalType()
	getUsers()
	return

angular.module('AllStarFitness')
	.controller 'WorkoutModalController', [
		'$scope'
		'$uibModalInstance'
		'WorkoutService'
		'LoginService'
		'UserService'
		'type'
		'workout'
		WorkoutModalController
	]
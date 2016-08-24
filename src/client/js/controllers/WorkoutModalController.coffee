WorkoutModalController = ($scope, $uibModalInstance, WorkoutService, LoginService, UserService) ->
	
	#ititialise variables
	$scope.users = { }
	$scope.search = { }
	$scope.workout = { }
	$scope.workout.description = ""
	$scope.loading = false
	currentUser = LoginService.getUserInfo()

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

		postWorkout()
		return

	$scope.cancel = ->
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

	#display error on form if there is an error
	formError = (errorText) ->
		$('.alert').remove()
		error_message = "<div class='alert alert-danger alert-dismissible' role='alert'>" + errorText + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button></div>"
		$('form').prepend(error_message)

	#validate form
	isNullOrEmptyOrUndefined = (value) ->
		!value

	getUsers()
	return

angular.module('AllStarFitness')
	.controller 'WorkoutModalController', [
		'$scope'
		'$uibModalInstance'
		'WorkoutService'
		'LoginService'
		'UserService'
		WorkoutModalController
	]
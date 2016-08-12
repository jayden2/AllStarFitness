WorkoutModalController = ($scope, $uibModalInstance, WorkoutService, LoginService, UserService) ->
	
	#ititialise variables
	$scope.users = { }
	$scope.search = { }
	$scope.loading = false
	currentUser = LoginService.getUserInfo()

	$scope.confirm = ->
		$uibModalInstance.close('postupdel')
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
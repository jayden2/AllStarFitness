UserController = ($scope, LoginService, UserService) ->

	#define users
	$scope.loading = false
	currentUser = LoginService.getUserInfo()
	$scope.users = {}

	#get all users
	$scope.getUsers = ->
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

	$scope.getUsers()

	return

angular.module('AllStarFitness')
	.controller 'UserController', [
		'$scope'
		'LoginService'
		'UserService'
		UserController
	]
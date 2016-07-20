LoginController = ($scope, $rootScope, $location, LoginService) ->

	#user define
	$scope.user = {}
	#error define
	$scope.error = "test"

	#login button
	$scope.login = ->
		LoginService.login($scope.user).then ((result) ->
			$scope.user = result
			#check if not correct and display user not found and password not correct :)
			if ($scope.user.token)
				#insert user as global
				$rootScope.user = result
				#goto dashboard
				$location.path '/dashboard'
			else
				$scope.error = $scope.user.message
				console.log 'error'
				console.log $scope.error
		), (error) ->
			$window.alert 'Invalid credentials'
			#console.log error
			return
		return

	return

angular.module('AllStarFitness')
	.controller 'LoginController', [
		'$scope'
		'$rootScope'
		'$location'
		'LoginService'
		LoginController
	]
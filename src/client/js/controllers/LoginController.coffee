LoginController = ($scope, $rootScope, $location, LoginService) ->

	#user define
	$scope.user = {}

	#login button
	$scope.login = ->
		$rootScope.user = {}
		console.log $scope.user.email
		console.log $scope.user.password
		console.log LoginService
		LoginService.login($scope.user)
		if ($rootScope.user.token)
			$location.path '/dashboard'
		else
			console.log 'error'

	return

angular.module('AllStarFitness')
	.controller 'LoginController', [
		'$scope'
		'$rootScope'
		'$location'
		'LoginService'
		LoginController
	]
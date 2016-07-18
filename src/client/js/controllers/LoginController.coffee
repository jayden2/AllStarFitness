LoginController = ($scope, $rootScope, $location, LoginService) ->

	#user define
	$scope.user = {}

	#login button
	$scope.login = ->
		LoginService.login($scope.user).then ((result) ->
			$scope.user = result
			if ($scope.user.token)
				$location.path '/dashboard'
			else
				console.log 'error'
		), (error) ->
			$window.alert 'Invalid credentials'
			console.log error
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
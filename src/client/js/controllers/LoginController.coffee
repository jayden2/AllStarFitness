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
				errorLogin()
		), (error) ->
			$window.alert 'Invalid credentials'
			console.log error
			return
		return

	#push error to form if wrong password or email
	errorLogin = ->
		error_message = "<div class='alert alert-danger alert-dismissible' role='alert'>" + $scope.error + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button></div>"
		$('form').prepend(error_message)
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
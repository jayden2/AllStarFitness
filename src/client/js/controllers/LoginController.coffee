LoginController = ($scope, $location, LoginService) ->

	#user define
	$scope.user = {}
	#error define
	$scope.error = "test"
	$scope.login_button = "Logins"
	loading = false

	#login button
	$scope.login = ->
		if loading == false
			loading = true
			loadingLogin(true)
			LoginService.login($scope.user).then ((result) ->
				loadingLogin(false)
				$scope.user = result
				#check if not correct and display user not found and password not correct :)
				if ($scope.user.token)
					#goto dashboard
					$location.path '/dashboard'
				else
					$scope.error = $scope.user.message
					console.log 'error'
					console.log $scope.error
					errorLogin()
				loading = false
			), (error) ->
				console.log error
				loading = false
				return
		return

	loadingLogin = (isLoading) ->
		loading_circle = "<i class='fa fa-cog fa-spin fa-2x fa-fw'></i>"
		loading_text = "loading"
		if isLoading
			$('.login-button').text("")
			$('.login-button').append(loading_circle)
		else
			$('.fa-cog').remove()
			$('.login-button').text("Login")
		return

	#push error to form if wrong password or email
	errorLogin = ->
		$('.alert').remove()
		error_message = "<div class='alert alert-danger alert-dismissible' role='alert'>" + $scope.error + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button></div>"
		$('form').prepend(error_message)
		return
	return

angular.module('AllStarFitness')
	.controller 'LoginController', [
		'$scope'
		'$location'
		'LoginService'
		LoginController
	]
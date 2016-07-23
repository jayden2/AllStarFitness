LoginService = ($http, $q, $window, $httpParamSerializerJQLike) ->
	login = (user) ->
		deferred = $q.defer()
		userSave = {}

		$http.post('/api/authenticate',
			email: user.email
			password: user.password).success ((result) ->
			if result.success == true
				userSave =
					success: result.success
					token: result.token
					first_name: result.first_name
					last_name: result.last_name
					message: result.message
					email: result.email
					id: result.id
				$window.sessionStorage['userSave'] = JSON.stringify(userSave)
				deferred.resolve userSave
				return
			else
				userSave =
					success: result.success
					message: result.message
				deferred.resolve userSave
				return
		), (error) ->
			console.log error
			deferred.reject error
			return
		deferred.promise

	logout = ->
		userSave = null
		$window.sessionStorage['userSave'] = null
		return

	getUserInfo = ->
		userSave = JSON.parse($window.sessionStorage['userSave'])

	init = ->
		if $window.sessionStorage['userSave']
			user = JSON.parse($window.sessionStorage['userSave'])
		return

	init()
	{
		login: login
		logout: logout
		getUserInfo: getUserInfo
	}

angular.module('AllStarFitness')
	.factory 'LoginService', [
		'$http'
		'$q'
		'$window'
		'$httpParamSerializerJQLike'
		LoginService
	]
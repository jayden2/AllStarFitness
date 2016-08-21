LoginService = ($http, $q, $window, $location, $cookieStore, $httpParamSerializerJQLike) ->
	login = (user) ->
		deferred = $q.defer()
		userSave = []

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
				$cookieStore.put 'user', JSON.stringify(userSave)

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
		$cookieStore.put 'user', null
		return

	getUserInfo = ->
		if JSON.parse($cookieStore.get('user')) != null
			userSave = JSON.parse($cookieStore.get('user'))
		else
			$location.path '/login'
		return userSave

	init = ->
		if $window.sessionStorage['userSave']
			userSave = JSON.parse($window.sessionStorage['userSave'])
		else
			userSave = JSON.parse($cookieStore.get('user'))
		return

	init()
	{
		login: login
		logout: logout
		getUserInfo: getUserInfo
		init: init
	}

angular.module('AllStarFitness')
	.factory 'LoginService', [
		'$http'
		'$q'
		'$window'
		'$location'
		'$cookieStore'
		'$httpParamSerializerJQLike'
		LoginService
	]
LoginService = ($http, $rootScope, $q, $window, $httpParamSerializerJQLike) ->
	login = (user) ->
		deferred = $q.defer()
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
		deferred = $q.defer()
		$http(
			url: '/api/logout'
			method: 'POST').then ((result) ->
			userSave = null
			$window.sessionStorage['userSave'] = null
			deferred.resolve result
			return
		), (error) ->
			deferred.reject error
			return
		deferred.promise

	getUserInfo = ->
		userSave

	init = ->
		if $window.sessionStorage['userSave']
			userSave = JSON.parse($window.sessionStorage['userSave'])
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
		'$rootScope'
		'$q'
		'$window'
		'$httpParamSerializerJQLike'
		LoginService
	]
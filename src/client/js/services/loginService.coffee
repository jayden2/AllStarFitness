LoginService = ($http, $rootScope, $q, $window, $httpParamSerializerJQLike) ->
	{
	login: (user) ->
		console.log $q.defer
		deferred = $q.defer()
		console.log user
		$http(
			url: '/api/authenticate/'
			method: 'POST'
			data: user
			headers: 'Content-Type': 'application/x-www-form-urlencoded').success ((result) ->
			$rootScope.userSave =
				token: result.data.token
				email: result.data.email
			$window.sessionStorage['userSave'] = JSON.stringify($rootScope.userSave)
			deferred.resolve user
			return
		), (error) ->
			console.log error
			deferred.reject error
			return
		deferred.promise

		logout: ->
			deferred = $q.defer()
			$http(
				method: 'POST'
				#url: '/api/logout'
				headers: 'access_token': userInfo.accessToken).then ((result) ->
				userSave = null
				$window.sessionStorage['userSave'] = null
				deferred.resolve result
				return
			), (error) ->
				deferred.reject error
        		return
        	deferred.promise

		getUserInfo: ->
      		userSave

		init: ->
			if $window.sessionStorage['userSave']
				userSave = JSON.parse($window.sessionStorage['userSave'])
			return

		init()
		{
			login: login
			logout: logout
			getUserInfo: getUserInfo
		}
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
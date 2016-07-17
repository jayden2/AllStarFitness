LoginService = ($http, $rootScope, $q, $window, $httpParamSerializerJQLike) ->
	{
	login: (user) ->
		deferred = $q.defer()
		console.log user
		$http(
			url: '/api/authenticate/'
			method: 'POST'
			data: user
			headers: 'Content-Type': 'application/x-www-form-urlencoded').success ((result) ->
			$rootScope.user =
				token: result.data.token
				email: result.data.email
			$window.sessionStorage['user'] = JSON.stringify($rootScope.user)
			deferred.resolve user
			return
		), (error) ->
				console.log error
				deffered.reject error
				return
			deffered.promise
		{ login: login }
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
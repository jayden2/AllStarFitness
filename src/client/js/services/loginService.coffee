LoginService = ($http) ->
	{
		post: (data) ->
			$http.get '/api/auth/', data
				.then successCallback, errorCallback
	}
	return

angular.module('AllStarFitness')
	.factory 'LoginService', [
		'$http'
		LoginService
	]
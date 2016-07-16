DashboardService = ($http) ->
	{
		post: (data) ->
			$http.get '/api/auth/', data
				.then successCallback, errorCallback
	}
	return

angular.module('AllStarFitness')
	.factory 'DashboardService', [
		'$http'
		DashboardService
	]
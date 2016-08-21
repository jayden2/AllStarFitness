MasterController = ($scope, $location) ->
	$scope.goToLogin = ->
		$location.path '/login'
		return
	return


angular.module('AllStarFitness')
	.controller 'MasterController', [
		'$scope'
		'$location'
		MasterController
	]

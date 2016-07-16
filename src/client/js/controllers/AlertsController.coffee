AlertsController = ($scope) ->
	$scope.alerts = [
		{
			type: 'success'
			message: 'message 1'
		}
		{
			type: 'danger'
			message: 'bug1111'
		}
	]

	$scope.addAlert = ->
		$scope.alerts.push msg: 'SDADS ALERT!'
		return

	$scope.closeAlert = (index) ->
		$scope.alerts.splice index, 1
		return
	return

angular.module('AllStarFitness')
	.controller 'AlertsController', [
		'$scope'
		AlertsController
	]
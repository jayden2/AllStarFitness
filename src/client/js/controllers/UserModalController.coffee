UserModalController = ($scope, $uibModalInstance, UserService, title, type) ->
	
	#ititialise variables
	$scope.title = title
	$scope.type = type

	#close modal confirm (save)
	$scope.confirm = ->
		$uibModalInstance.close()
	#close modal cancel
	$scope.cancel = ->
		$uibModalInstance.dismiss('cancel')
	return

angular.module('AllStarFitness')
	.controller 'UserModalController', [
		'$scope'
		'$uibModalInstance'
		'UserService'
		'title'
		'type'
		UserModalController
	]
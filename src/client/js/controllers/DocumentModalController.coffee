DocumentModalController = ($scope, $uibModalInstance, DocumentService, LoginService, type, doc) ->
	
	#ititialise variables
	$scope.type = type
	savedDoc = angular.copy(doc)
	$scope.doc = doc
	$scope.loading = false
	currentUser = LoginService.getUserInfo()

	return

angular.module('AllStarFitness')
	.controller 'DocumentModalController', [
		'$scope'
		'$uibModalInstance'
		'DocumentService'
		'LoginService'
		'type'
		'doc'
		UserModalController
	]
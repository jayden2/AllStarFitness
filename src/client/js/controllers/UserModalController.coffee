UserModalController = ($scope, $uibModalInstance, UserService, type, user) ->
	
	#ititialise variables
	$scope.type = type

	#title of modal
	chooseModalType = ->
		if type == "create"
			$scope.title = "Create User"
			$scope.buttonSave = "Create User"
			$scope.buttonDelete = false
		else
			$scope.title = "Edit User"
			$scope.buttonSave = "Save User"
			$scope.buttonDelete = true

	#close modal confirm (save)
	$scope.confirm = ->
		$uibModalInstance.close()
	#close modal delete
	$scope.delete = ->
		$uibModalInstance.close()
	#close modal cancel
	$scope.cancel = ->
		$uibModalInstance.dismiss('cancel')

	chooseModalType()

	return

angular.module('AllStarFitness')
	.controller 'UserModalController', [
		'$scope'
		'$uibModalInstance'
		'UserService'
		'user'
		'type'
		UserModalController
	]
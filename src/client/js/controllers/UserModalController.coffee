UserModalController = ($scope, $uibModalInstance, UserService, LoginService, type, user) ->
	
	#ititialise variables
	$scope.type = type
	$scope.user = user
	$scope.loading = false
	currentUser = LoginService.getUserInfo()

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
		$scope.genderToChar()
		
		if type == "create"
			$scope.postUser()
		else
			$scope.updateUser()
		$uibModalInstance.close()

	#close modal delete
	$scope.delete = ->
		$scope.deleteUser()
		$uibModalInstance.close()
		
	#close modal cancel
	$scope.cancel = ->
		$uibModalInstance.dismiss('cancel')

	#date time picker
	$scope.today = ->
		$scope.dt = new Date()

	$scope.open2 = ->
		$scope.popup2.opened = true

	$scope.popup2 =
		opened: false

	#calculate age
	$scope.getAge = ->
		today = new Date()
		birthDate = new Date($scope.dt)
		age = today.getFullYear() - birthDate.getFullYear()
		m = today.getMonth() - birthDate.getMonth()
		if (m < 0 || (m == 0 && today.getDate() < birthDate.getDate()))
			age--
		$scope.user.age = age

	#get gender
	$scope.getGender = ->
		if user.gender == "m"
			$scope.gender = "male"
		else
			$scope.gender = "female"

	$scope.genderToChar = ->
		if $scope.gender == "male"
			$scope.user.gender = "m"
		else
			$scope.user.gender = "f"

	#post user
	$scope.postUser = ->
		if $scope.loading == false
			$scope.loading = true
			UserService.createUser($scope.user, currentUser.token).then ((result) ->
				$scope.users = result
				$scope.loading = false
			), (error) ->
				console.log error
				$scope.loading = false
				return
		return

	#update user
	$scope.updateUser = ->
		if $scope.loading == false
			$scope.loading = true
			UserService.updateUser($scope.user, $scope.user.id, currentUser.token).then ((result) ->
				$scope.users = result
				$scope.loading = false
			), (error) ->
				console.log error
				$scope.loading = false
				return
		return

	#delete user
	$scope.deleteUser = ->
		if $scope.loading == false
			$scope.loading = true
			UserService.deleteUser($scope.user.id, currentUser.token).then ((result) ->
				$scope.users = result
				$scope.loading = false
			), (error) ->
				console.log error
				$scope.loading = false
				return
		return

	chooseModalType()
	$scope.today()
	$scope.getAge()
	$scope.getGender()

	return

angular.module('AllStarFitness')
	.controller 'UserModalController', [
		'$scope'
		'$uibModalInstance'
		'UserService'
		'LoginService'
		'type'
		'user'
		UserModalController
	]
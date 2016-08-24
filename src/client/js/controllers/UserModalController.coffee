UserModalController = ($scope, $uibModalInstance, UserService, LoginService, type, user) ->
	
	#ititialise variables
	$scope.type = type
	savedUser = angular.copy(user)
	$scope.user = user
	$scope.loading = false
	currentUser = LoginService.getUserInfo()
	$scope.altInputFormats = ['M!/d!/yyyy']

	$scope.colours = [
		{
			id: 'blue'
			name: 'Blue'
		}
		{
			id: 'green'
			name: 'Green'
		}
		{
			id: 'orange'
			name: 'Orange'
		}
		{
			id: 'red'
			name: 'Red'
		}
		{
			id: 'pink'
			name: 'Pink'
		}
		{
			id: 'purple'
			name: 'Purple'
		}
		{
			id: 'black'
			name: 'Black'
		}
		{
			id: 'yellow'
			name: 'Yellow'
		}
	]

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
		if isNullOrEmptyOrUndefined($scope.user.first_name)
			formError("First name is empty")
			return
		if isNullOrEmptyOrUndefined($scope.user.last_name)
			formError("Surname is empty")
			return
		if isNullOrEmptyOrUndefined($scope.user.email)
			formError("Email is not valid")
			return
		if isValidDate()
			formError("Incorrect date format")
			return
		$scope.user.age = $scope.dt
		if type == "create"
			$scope.postUser()
		else
			$scope.updateUser()
		

	#close modal delete
	$scope.delete = ->
		$scope.deleteUser()
		
	#close modal cancel
	$scope.cancel = ->
		$scope.user.age = savedUser.age
		$scope.user.first_name = savedUser.first_name
		$scope.user.last_name = savedUser.last_name
		$scope.user.email = savedUser.email
		$uibModalInstance.dismiss('cancel')

	#date time picker
	$scope.today = ->
		if type == 'create'
			$scope.dt = new Date()
		else
			$scope.dt = new Date(user.age)

	#caleder open/close
	$scope.open1 = ->
		$scope.popup1.opened = true
	#caleder open/close
	$scope.popup1 =
		opened: false

	#calculate age
	$scope.getAge = ->
		if isNaN($scope.dt) == false
			today = new Date()
			birthDate = new Date($scope.dt)
			age = today.getFullYear() - birthDate.getFullYear()
			m = today.getMonth() - birthDate.getMonth()
			if (m < 0 || (m == 0 && today.getDate() < birthDate.getDate()))
				age--
			$scope.age = age

	#post user
	$scope.postUser = ->
		if $scope.loading == false
			$scope.loading = true
			UserService.createUser($scope.user, currentUser.token).then ((result) ->
				$scope.users = result
				$scope.loading = false
				$uibModalInstance.close('postupdel')
			), (error) ->
				console.log error
				$scope.loading = false
				$uibModalInstance.close('postupdel')
				return
		return

	#update user
	$scope.updateUser = ->
		if $scope.loading == false
			$scope.loading = true
			UserService.updateUser($scope.user, $scope.user.id, currentUser.token).then ((result) ->
				$scope.users = result
				$scope.loading = false
				$uibModalInstance.close('postupdel')
			), (error) ->
				console.log error
				$scope.loading = false
				$uibModalInstance.close('postupdel')
				return
		return

	#delete user
	$scope.deleteUser = ->
		if $scope.loading == false
			$scope.loading = true
			UserService.deleteUser($scope.user.id, currentUser.token).then ((result) ->
				$scope.users = result
				$scope.loading = false
				$uibModalInstance.close('postupdel')
			), (error) ->
				console.log error
				$scope.loading = false
				$uibModalInstance.close('postupdel')
				return
		return

	#display error on form if there is an error
	formError = (errorText) ->
		$('.alert').remove()
		error_message = "<div class='alert alert-danger alert-dismissible' role='alert'>" + errorText + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button></div>"
		$('form').prepend(error_message)

	#validate form
	isNullOrEmptyOrUndefined = (value) ->
		!value

	isValidDate = ->
		test = $scope.dt
		valid = Date.parse(test)
		if isNullOrEmptyOrUndefined(valid)
			return true
		else
			return false

	chooseModalType()
	$scope.today()
	$scope.getAge()

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
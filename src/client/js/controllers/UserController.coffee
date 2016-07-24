UserController = ($scope, $filter, $uibModal, LoginService, UserService) ->

	#define users
	$scope.loading = false
	$scope.resultAmount = false
	$scope.search = { }
	currentUser = LoginService.getUserInfo()
	$scope.users = {}

	#get all users from service to fill table
	$scope.getUsers = ->
		if $scope.loading == false
			$scope.loading = true
			UserService.getAllUsers(currentUser.token).then ((result) ->
				$scope.users = result
				$scope.loading = false
			), (error) ->
				console.log error
				$scope.loading = false
				return
		return

	#search and filter users from search
	$scope.filteredUsers = ->
		$scope.resultAmount = false
		array = []
		for key of $scope.users
			$scope.resultAmount = true
			`key = key`
			array.push $scope.users[key]
		return $filter('filter') array, $scope.search.query

	$scope.openModal = (typeModal, user) ->
		modalInstance = $uibModal.open(
			animation: true
			templateUrl: '/js/directives/modal-user.html'
			controller: 'UserModalController'
			resolve:
				type: ->
					typeModal
				user: ->
					user
		)


	$scope.getUsers()

	return

angular.module('AllStarFitness')
	.controller 'UserController', [
		'$scope'
		'$filter'
		'$uibModal'
		'LoginService'
		'UserService'
		UserController
	]
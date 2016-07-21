DashboardController = ($scope, $cookieStore, $location, LoginService) ->
	## Sidebar
	## Cookie control
	mobileView = 992

	$scope.getWidth = ->
		return window.innerWidth

	$scope.$watch $scope.getWidth, (newValue, oldValue) ->
		if newValue >= mobileView
			if angular.isDefined($cookieStore.get('toggle'))
				$scope.toggle = if !$cookieStore.get('toggle') then false else true
			else
				$scope.toggle = true
		else
			$scope.toggle = false
		return

	$scope.toggleSidebar = ->
		$scope.toggle = !$scope.toggle
		$cookieStore.put 'toggle', $scope.toggle
		return

	window.onresize = ->
		$scope.$apply()
		return

	$scope.logout = ->
		LoginService.logout().then ((result) ->
			$scope.user = null
			$location.path '/login'
			return
		), (error) ->
			console.log error
			return
		return
	return

angular.module('AllStarFitness')
	.controller 'DashboardController', [
		'$scope'
		'$cookieStore'
		'$location'
		'LoginService'
		DashboardController
	]

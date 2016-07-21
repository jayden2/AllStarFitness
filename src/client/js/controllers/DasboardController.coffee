DashboardController = ($scope, $cookieStore, $location, LoginService) ->
	## Sidebar
	## Cookie control
	mobileView = 992
	#user from routes
	$scope.user = LoginService.getUserInfo()

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
		LoginService.logout()
		$scope.user = null
		$location.path '/login'
		return

	#dashboard location of path
	$scope.getLocation = ->
		dash_loc = $location.path().substring(1).replace('dashboard/', '').trim()
		dash_sub = $location.path().substring(1).replace('/', ' / ').trim()

		$scope.dashboard_location = dash_loc.charAt(0).toUpperCase() + dash_loc.slice(1)
		$scope.dashboard_location_sub = dash_sub.charAt(0).toUpperCase() + dash_sub.slice(1)
		return

	$scope.getLocation()
	
	return

angular.module('AllStarFitness')
	.controller 'DashboardController', [
		'$scope'
		'$cookieStore'
		'$location'
		'LoginService'
		DashboardController
	]

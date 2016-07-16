MasterController = ($scope, $cookieStore, $location) ->
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

	$scope.$on '$routeChangeStart', (next, current) ->
		switch $location.url()
			when '/dashboard' then $scope.sidebar = true
			when '/dashboard/users' then $scope.sidebar = true
			when '/test' then $scope.sidebar = true
			when '/' then $scope.sidebar = true
			else
				$scope.sidebar = false
				$('#page-wrapper').css('padding-left', '0px')
		console.log $location.url()
		console.log $scope.sidebar
		return

	return


angular.module('AllStarFitness')
	.controller 'MasterController', [
		'$scope'
		'$cookieStore'
		'$location'
		MasterController
	]

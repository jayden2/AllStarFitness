angular.module('AllStarFitness').config [
	'$routeProvider'
	'$locationProvider'
	($routeProvider, $locationProvider) ->
		$routeProvider
			.when('/',
				controller: 'MasterController'
				templateUrl: 'views/home.html'
				)
			.when('/login',
				controller: 'DashboardController'
				templateUrl: 'views/login.html'
				)
			.when('/dashboard',
				controller: 'DashboardController'
				templateUrl: 'views/dashboard.html'
				)
			.when('/test',
				controller: 'DashboardController'
				templateUrl: 'views/test.html'
				)
			.when('/dashboard/users',
				controller: 'UserController'
				templateUrl: 'views/users.html'
				)
			.otherwise redirectTo: '/'
		
		#this is to remove the hash(#) using the history api
		$locationProvider.html5Mode(true)
]
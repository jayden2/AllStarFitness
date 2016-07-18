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
				###
				resolve: auth: [
					'$rootScope'
					'$q'
					'LoginService'
					
					($rootScope, $q, LoginService) ->
						LoginService.login()
						if $rootScope.userSave
							$q.when $rootScope.userSave
						else
							$q.reject authenticated: false
					
				]
				###
				)
			.when('/test',
				controller: 'DashboardController'
				templateUrl: 'views/test.html'
				auth: true
				)
			.when('/dashboard/users',
				controller: 'UserController'
				templateUrl: 'views/users.html'
				auth: true
				)
			.when('/test',
				controller: 'MasterController'
				templateUrl: 'views/test.html'
				auth: true
				)
			.otherwise redirectTo: '/'
		
		#this is to remove the hash(#) using the history api
		$locationProvider.html5Mode(true)
]
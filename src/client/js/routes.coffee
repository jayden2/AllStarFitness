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
				controller: 'LoginController'
				templateUrl: 'views/login.html'
				)
			.when('/dashboard',
				controller: 'DashboardController'
				templateUrl: 'views/dashboard.html'
				resolve: auth: [
					'$q'
					'$location'
					'LoginService'
					
					($q, $location, LoginService) ->
						#get user details!
						userAuth = LoginService.getUserInfo()
						if userAuth
							$q.when userAuth
						else
							$q.reject authenticated: false
							$location.path '/login'
				])
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
angular.module('AllStarFitness').config [
	'$routeProvider'
	'$locationProvider'
	($routeProvider, $locationProvider) ->
		$routeProvider
			##HOME
			.when('/',
				controller: 'MasterController'
				templateUrl: 'views/home.html'
				)
			##LOGIN
			.when('/login',
				controller: 'LoginController'
				templateUrl: 'views/login.html'
				)
			##DASHBOARD
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
			#PUBLISH WORKOUT
			.when('/dashboard/publish/:id',
				controller: 'PublishController'
				templateUrl: 'views/publish-view.html'
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
			##DASH USERS
			.when('/dashboard/users',
				controller: 'UserController'
				templateUrl: 'views/users.html'
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
			##DASH WORKOUTS
			.when('/dashboard/exercises',
				controller: 'ExerciseController'
				templateUrl: 'views/exercises.html'
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
			##DASH WORKOUTS
			.when('/dashboard/workouts',
				controller: 'WorkoutController'
				templateUrl: 'views/workouts.html'
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
			##DASH WORKOUTS --EDIT
			.when('/dashboard/workouts/edit/:id',
				controller: 'WorkoutEditController'
				templateUrl: 'views/workout-edit.html'
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
			.otherwise redirectTo: '/'
		
		#this is to remove the hash(#) using the history api
		$locationProvider.html5Mode(true)
]
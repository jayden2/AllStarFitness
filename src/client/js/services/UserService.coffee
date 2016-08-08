UserService = ($http, $q, $window, $httpParamSerializerJQLike) ->
	##CREATE USER
	createUser = (user, token) ->
		deferred = $q.defer()
		$http.post('/api/users/' + '?token=' + token,
			first_name: user.first_name
			last_name: user.last_name
			email: user.email
			user_type: 'none'
			gender: user.gender
			age: user.age
			date_created: user.date_created).success ((result) ->
			if result.success == true
				userSave =
					success: result.success
					message: result.message
				deferred.resolve userSave
				return
		), (error) ->
			deferred.reject error
			return
		deferred.promise
	
	##GET ALL USERS
	getAllUsers = (token) ->
		deferred = $q.defer()
		userSave = {}
		$http.get('/api/users/' + '?token=' + token).success ((result) ->
			if result
				userSave = result
				deferred.resolve userSave
				return
			else
				userSave =
					success: false
					message: 'User not found!'
				deferred.resolve userSave
				return
		), (error) ->
			console.log error
			deferred.reject error
			return
		deferred.promise

	#GET ONE USER
	getOneUser = (id, token) ->
		deferred = $q.defer()
		userSave = {}
		$http.get('/api/users/' + id + '?token=' + token).success ((result) ->
			if result
				userSave =
					success: true
					id: result.id
					first_name: result.first_name
					last_name: result.last_name
					email: result.email
					user_type: result.user_type
					gender: result.gender
					age: result.gender
					date_created: result.date_created
					date_updated: result.date_updated
				deferred.resolve userSave
				return
			else
				userSave=
					success: false
					message: 'User not found!'
				deferred.resolve userSave
				return
		), (error) ->
			console.log error
			deferred.reject error
			return
		deferred.promise

	##UPDATE USER
	updateUser = (user, id, token) ->
		deferred = $q.defer()
		$http.put('/api/users/' + id + '?token=' + token,
			first_name: user.first_name
			last_name: user.last_name
			email: user.email
			user_type: 'none'
			gender: user.gender
			age: user.age).success ((result) ->
				if result.success == true
					userSave =
						success: result.success
						message: result.message
					deferred.resolve userSave
					return
		), (error) ->
			deferred.reject error
			return
		deferred.promise

	##DELETE USER
	deleteUser = (id, token) ->
		deferred = $q.defer()
		$http.delete('/api/users/' + id + '?token=' + token).success ((result) ->
			if result.success == true
				userSave =
					success: result.success
					message: result.message
				deferred.resolve userSave
				return
		), (error) ->
			deferred.reject error
			return
		deferred.promise

	{
		createUser: createUser
		getAllUsers: getAllUsers
		getOneUser: getOneUser
		updateUser: updateUser
		deleteUser: deleteUser
	}

angular.module('AllStarFitness')
	.factory 'UserService', [
		'$http'
		'$q'
		'$window'
		'$httpParamSerializerJQLike'
		UserService
	]
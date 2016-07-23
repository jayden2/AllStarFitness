DocumentService = ($http, $q, $window, $httpParamSerializerJQLike) ->
	
	##CREATE DOCUMENT
	createDocument = (document, token) ->
		deferred = $q.defer()
		$http.post('/api/documents/' + '?token=' + token,
			first_name: user.first_name
			last_name: user.last_name
			email: user.email
			user_type: 'none'
			password: 'none'
			gender: user.gender
			age: user.age
			date_created: user.date_created).success ((result) ->
			if result.success == true
				documentSave =
					success: result.success
					message: result.message
				deferred.resolve documentSave
				return
		), (error) ->
			deferred.reject error
			return
		deferred.promise

	#GET ALL DOCUMENTS
	getAllDocuments = (document, token) ->
		deferred = $q.defer()
		documentSave = {}
		#push into object array
		$http.get('/api/documents/' + '?token=' + token).success ((result) ->
			if result
				documentSave =
					id: result.id
					first_name: result.first_name
					last_name: result.last_name
					email: result.email
					user_type: result.user_type
					gender: result.gender
					age: result.gender
					date_created: result.date_created
					date_updated: result.date_updated
				deferred.resolve documentSave
				return
			else
				documentSave =
					success: false
					message: 'Document not found!'
				deferred.resolve documentSave
				return
		), (error) ->
			console.log error
			deferred.reject error
			return
		deferred.promise

	#GET ONE DOCUMENT
	getOneDocument = (id, token) ->
		deferred = $q.defer()
		documentSave = {}
		$http.get('/api/documents/' + id + '?token=' + token).success ((result) ->
			if result
				documentSave =
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
				deferred.resolve documentSave
				return
			else
				documentSave=
					success: false
					message: 'Document not found!'
				deferred.resolve documentSave
				return
		), (error) ->
			console.log error
			deferred.reject error
			return
		deferred.promise

	##UPDATE DOCUMENTS
	updateDocument = (document, id, token) ->
		deferred = $q.defer()
		$http.post('/api/documents/' + id + '?token=' + token,
			first_name: user.first_name
			last_name: user.last_name
			email: user.email
			user_type: 'none'
			password: 'none'
			gender: user.gender
			age: user.age
			date_created: user.date_created).success ((result) ->
			if result.success == true
				documentSave =
					success: result.success
					message: result.message
				deferred.resolve documentSave
				return
		), (error) ->
			deferred.reject error
			return
		deferred.promise

		##DELETE DOCUMENT
		deleteDocument = (id, token) ->
			deferred = $q.defer()
			$http.post('/api/documents/' + id + '?token=' + token).success ((result) ->
				if result.success == true
					documentSave =
						success: result.success
						message: result.message
					deferred.resolve documentSave
					return
			), (error) ->
				deferred.reject error
				return
			deferred.promise

angular.module('AllStarFitness')
	.factory 'DocumentService', [
		'$http'
		'$q'
		'$window'
		'$httpParamSerializerJQLike'
		DocumentService
	]
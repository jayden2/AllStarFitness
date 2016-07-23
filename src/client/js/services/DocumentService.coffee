DocumentService = ($http, $q, $window, $httpParamSerializerJQLike) ->
	
	##CREATE DOCUMENT
	createDocument = (doc, token) ->
		deferred = $q.defer()
		$http.post('/api/documents/' + '?token=' + token,
			title: doc.title
			collection: doc.collection
			user_id: doc.user_id
			template: doc.template
			date_created: doc.date_created).success ((result) ->
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
	getAllDocuments = (token) ->
		deferred = $q.defer()
		documentSave = {}
		$http.get('/api/documents/' + '?token=' + token).success ((result) ->
			if result
				documentSave = result
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
					id: result.id
					title: result.title
					collection: result.collection
					user_id: result.user_id
					template: result.template
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
	updateDocument = (doc, id, token) ->
		deferred = $q.defer()
		$http.put('/api/documents/' + id + '?token=' + token,
			title: doc.title
			collection: doc.collection
			user_id: doc.user_id
			template: doc.template).success ((result) ->
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
			$http.delete('/api/documents/' + id + '?token=' + token).success ((result) ->
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
		

	{
		createDocument: createDocument
		getAllDocuments: getAllDocuments
		getOneDocument: getOneDocument
		updateDocument: updateDocument
		deleteDocument: deleteDocument
	}

angular.module('AllStarFitness')
	.factory 'DocumentService', [
		'$http'
		'$q'
		'$window'
		'$httpParamSerializerJQLike'
		DocumentService
	]
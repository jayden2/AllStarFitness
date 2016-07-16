user = require './server/models/user'
workout = require './server/models/workout'
doc = require './server/models/document'

module.exports = (router) ->

	#api
	router.get '/api', (req, res) ->
		res.json message: 'AllStarFitness API up and running! What would you like sir?'

	#authenticate user!
	router.post '/api/authenticate/', (req, res) ->
		user.checkValidUser app, req.body, res

	#checkValidEmail
	router.get '/api/users/:email/check/', (req, res) ->
		user.checkValidEmail req.params.email, res

	#openshift health
	router.get '/health', (req, res) ->
		res.writeHead 200
		res.end()

	#api middleware for all requests
	router.use '/api/', (req, res, next) ->
		user.verifyUser req, res, next

	##----------------##
	##--USER ROUTES---##
	##----------------##
	
	#create user
	router.post '/api/users/', (req, res) ->
		user.createUser req.body, res

	#get all users
	router.get '/api/users/', (req, res) ->
		user.getAllUsers res
	
	#get 1 user
	router.get '/api/users/:id/', (req, res) ->
		user.getSingleUser req.params.id, res
	
	#update user
	router.put '/api/users/:id/', (req, res) ->
		user.updateUser req.body, req.params.id, res
	
	#delete user
	router.delete '/api/users/:id/', (req, res) ->
		user.deleteUser req.params.id, res

	##----------------##
	##-WORKOUT ROUTES-##
	##----------------##

	#create workout
	router.post '/api/workouts/', (req, res) ->
		workout.createWorkout req.body, res

	#get all workouts
	router.get '/api/workouts/', (req, res) ->
		workout.getAllWorkouts res
	
	#get 1 workout
	router.get '/api/workouts/:id/', (req, res) ->
		workout.getSingleWorkout req.params.id, res

	#get 1 workout --SHORT
	router.get '/api/workouts/:id/short', (req, res) ->
		workout.getSingleWorkoutShort req.params.id, res
	
	#update workout
	router.put '/api/workouts/:id/', (req, res) ->
		workout.updateWorkout req.body, req.params.id, res

	#update workout -- FAVOURITE
	router.put '/api/workouts/:id/favourite', (req, res) ->
		workout.updateWorkoutFavourite req.body, req.params.id, res
	
	#delete workout
	router.delete '/api/workouts/:id/', (req, res) ->
		workout.deleteWorkout req.params.id, res

	##-----------------##
	##-DOCUMENT ROUTES-##
	##-----------------##

	#create document
	router.post '/api/documents/', (req, res) ->
		doc.createDocument req.body, res

	#get all document
	router.get '/api/documents/', (req, res) ->
		doc.getAllDocuments res
	
	#get 1 document
	router.get '/api/documents/:id/', (req, res) ->
		doc.getSingleDocument req.params.id, res

	#get 1 document --SHORT
	router.get '/api/documents/:id/short', (req, res) ->
		doc.getSingleDocumentShort req.params.id, res
	
	#update document
	router.put '/api/documents/:id/', (req, res) ->
		doc.updateDocument req.body, req.params.id, res

	#update document -- TEMPLATE
	router.put '/api/documents/:id/template', (req, res) ->
		doc.updateDocumentTemplate req.body, req.params.id, res
	
	#delete document
	router.delete '/api/documents/:id/', (req, res) ->
		doc.deleteDocument req.params.id, res

	##--ANGULAR ROUTES--##
	router.get '*', (req, res) ->
		#load public/index.html
		res.sendFile __dirname + '/client/index.html'
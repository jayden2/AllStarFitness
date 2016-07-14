user = require './models/user'
workout = require './models/workout'
doc = require './models/document'

module.exports = configure: (app, router) ->

	#api
	router.get '/', (req, res) ->
		res.json message: 'AllStarFitness API up and running! What would you like sir?'

	#authenticate user!
	router.post '/authenticate/', (req, res) ->
		user.checkValidUser app, req.body, res

	#checkValidEmail
	router.get '/users/:email/check/', (req, res) ->
		user.checkValidEmail req.params.email, res

	#api middleware for all requests
	router.use (req, res, next) ->
		user.verifyUser req, res, next

	##----------------##
	##--USER ROUTES---##
	##----------------##
	
	#create user
	router.post '/users/', (req, res) ->
		user.createUser req.body, res

	#get all users
	router.get '/users/', (req, res) ->
		user.getAllUsers res
	
	#get 1 user
	router.get '/users/:id/', (req, res) ->
		user.getSingleUser req.params.id, res
	
	#update user
	router.put '/users/:id/', (req, res) ->
		user.updateUser req.body, req.params.id, res
	
	#delete user
	router.delete '/users/:id/', (req, res) ->
		user.deleteUser req.params.id, res

	##----------------##
	##-WORKOUT ROUTES-##
	##----------------##

	#create workout
	router.post '/workouts/', (req, res) ->
		workout.createWorkout req.body, res

	#get all workouts
	router.get '/workouts/', (req, res) ->
		workout.getAllWorkouts res
	
	#get 1 workout
	router.get '/workouts/:id/', (req, res) ->
		workout.getSingleWorkout req.params.id, res

	#get 1 workout --SHORT
	router.get '/workouts/:id/short', (req, res) ->
		workout.getSingleWorkoutShort req.params.id, res
	
	#update workout
	router.put '/workouts/:id/', (req, res) ->
		workout.updateWorkout req.body, req.params.id, res

	#update workout -- FAVOURITE
	router.put '/workouts/:id/favourite', (req, res) ->
		workout.updateWorkoutFavourite req.body, req.params.id, res
	
	#delete workout
	router.delete '/workouts/:id/', (req, res) ->
		workout.deleteWorkout req.params.id, res

	##-----------------##
	##-DOCUMENT ROUTES-##
	##-----------------##

	#create document
	router.post '/documents/', (req, res) ->
		doc.createDocument req.body, res

	#get all document
	router.get '/documents/', (req, res) ->
		doc.getAllDocuments res
	
	#get 1 document
	router.get '/documents/:id/', (req, res) ->
		doc.getSingleDocument req.params.id, res

	#get 1 document --SHORT
	router.get '/documents/:id/short', (req, res) ->
		doc.getSingleDocumentShort req.params.id, res
	
	#update document
	router.put '/documents/:id/', (req, res) ->
		doc.updateDocument req.body, req.params.id, res

	#update document -- TEMPLATE
	router.put '/documents/:id/template', (req, res) ->
		doc.updateDocumentTemplate req.body, req.params.id, res
	
	#delete document
	router.delete '/documents/:id/', (req, res) ->
		doc.deleteDocument req.params.id, res


	##GLOBAL ROUTE##
	#prepend all api calls with /api exp: /api/users/
	app.use '/api', router
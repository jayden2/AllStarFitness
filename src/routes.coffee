user = require './server/models/user'
exercise = require './server/models/exercise'
workout = require './server/models/workout'

module.exports = (router) ->

	#api
	router.get '/api', (req, res) ->
		res.json message: 'AllStarFitness API up and running! What would you like sir?'

	#authenticate user!
	router.post '/api/authenticate/', (req, res) ->
		user.checkValidUser req.body, res

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

	##-----------------##
	##-EXERCISE ROUTES-##
	##-----------------##

	#create exercise
	router.post '/api/exercises/', (req, res) ->
		exercise.createExercise req.body, res

	#upload image for exercise
	router.post '/api/exercises/image/', (req, res) ->
		exercise.uploadImage req, res

	#get all exercises
	router.get '/api/exercises/', (req, res) ->
		exercise.getAllExercises res
	
	#get 1 exercise
	router.get '/api/exercises/:id/', (req, res) ->
		exercise.getSingleExercise req.params.id, res

	#get 1 exercise --SHORT
	router.get '/api/exercises/:id/short/', (req, res) ->
		exercise.getSingleExerciseShort req.params.id, res
	
	#update exercise
	router.put '/api/exercises/:id/', (req, res) ->
		exercise.updateExercise req.body, req.params.id, res

	#update exercise -- FAVOURITE
	router.put '/api/exercises/:id/favourite/', (req, res) ->
		exercise.updateExerciseFavourite req.body, req.params.id, res
	
	#delete exercise
	router.delete '/api/exercises/:id/', (req, res) ->
		exercise.deleteExercise req.params.id, res

	##----------------##
	##-WORKOUT ROUTES-##
	##----------------##

	#create workout
	router.post '/api/workouts/', (req, res) ->
		workout.createWorkout req.body, res

	#get all workout
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

	#update workout -- TEMPLATE
	router.put '/api/workouts/:id/template/', (req, res) ->
		workout.updateWorkoutTemplate req.body, req.params.id, res
	
	#delete workout
	router.delete '/api/workouts/:id/', (req, res) ->
		workout.deleteWorkout req.params.id, res

	##--ANGULAR ROUTES--##
	router.get '*', (req, res) ->
		#load public/index.html
		res.sendFile __dirname + '/client/index.html'
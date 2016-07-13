user = require './models/user'

module.exports = configure: (app, router) ->

	#api
	router.get '/', (req, res) ->
		res.json message: 'AllStarFitness API up and running! What would you like sir?'

	#authenticate user!
	router.post '/authenticate/', (req, res) ->
		user.checkValidUser app, req.body, res

	#create user
	router.post '/users/', (req, res) ->
		user.createUser req.body, res

	#checkValidEmail
	router.get '/users/:email/check/', (req, res) ->
		user.checkValidEmail req.params.email, res

	#api middleware for all requests
	router.use (req, res, next) ->
		user.verifyUser req, res, next

	##----------------##
	##--USER ROUTES---##
	##----------------##
	
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

	##GLOBAL ROUTE##
	#prepend all api calls with /api exp: /api/users/
	app.use '/api', router
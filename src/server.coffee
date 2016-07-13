#packages
express = require 'express'
bodyparser = require 'body-parser'
morgan = require 'morgan'
connection = require './config/connection'
routes = require './routes'

#configure app and get data from post
app = express()
app.use bodyparser.urlencoded(extended: true)
app.use bodyparser.json()

#set port
port = process.env.PORT || 1199

#configure app CORS requests
app.use (req, res, next) ->
	res.setHeader 'Access-Control-Allow-Origin', '*'
	res.setHeader 'Access-Control-Allow-Methods', 'GET, POST'
	res.setHeader 'Access-Control-Allow-Headers', 'X-Requested-With,content-type, Authorization'
	next()

#log requests to console
app.use morgan 'dev'

#set  and routes routes
router = express.Router()
connection.init()
routes.configure(app, router)

#start server
server = app.listen(port)
console.log 'Server started on port ' + port
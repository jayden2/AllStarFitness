#packages
express = require 'express'
bodyparser = require 'body-parser'
morgan = require 'morgan'
connection = require './server/config/connection'

#configure app and get data from post
app = express()
app.use bodyparser.urlencoded(extended: true)
app.use bodyparser.json()
app.use express['static'](__dirname + '/client')

#set port
port = process.env.PORT || 8080
server_port = process.env.OPENSHIFT_NODEJS_PORT || 8080
#set ip
server_ip_address = process.env.OPENSHIFT_NODEJS_IP || '127.0.0.1'

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
require('./routes')(app);

#start server
server = app.listen(server_port, server_ip_address)
console.log "Listening on " + server_ip_address + ", server_port " + port
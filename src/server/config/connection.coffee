mysql = require('mysql')
require('dotenv').config()

#create connection pool
module.exports = class Connection
	@pool = null
	#initiase connection pool with username, password database etc
	@init: ->
		@pool = mysql.createPool(
			connectionLimit: 10
			host: process.env.DB_HOST_LOCAL
			port: process.env.DB_PORT
			user: process.env.DB_USER
			password: process.env.DB_PASS
			database: process.env.DB_NAME)
	#connect and get callback
	@acquire: (callback) ->
		@pool.getConnection (err, connection) ->
			callback err, connection
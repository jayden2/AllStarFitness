mysql = require('mysql')

#create connection pool
module.exports = class Connection
	@pool = null
	#initiase connection pool with username, password database etc
	@init: ->
		@pool = mysql.createPool(
			connectionLimit: 10
			#127.3.143.130 change to for prod
			host: 'localhost'
			port: '3306'
			user: 'admindEJ2fyi'
			password: 'NeduHQFdnB6k'
			database: 'allstarfitness')
	#connect and get callback
	@acquire: (callback) ->
		@pool.getConnection (err, connection) ->
			callback err, connection
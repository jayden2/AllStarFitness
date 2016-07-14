mysql = require('mysql')

#create connection pool
module.exports = class Connection
	@pool = null
	#initiase connection pool with username, password database etc
	@init: ->
		@pool = mysql.createPool(
			connectionLimit: 10
			host: 'localhost'
			port: '3306'
			user: 'adminl8yAzvl'
			password: 'ewI3RaVui6Ml'
			database: 'allstarfitness')
	#connect and get callback
	@acquire: (callback) ->
		@pool.getConnection (err, connection) ->
			callback err, connection
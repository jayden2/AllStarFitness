connection = require '../config/connection'

module.exports = class User
	#get all users
	#do connection, select all from users
	@getAllUsers = (res) ->
		connection.acquire (err, con) ->
			con.query 'SELECT * FROM users', (err, result) ->
				con.release()
				res.send result
				return
			return
		return
	#get one user
	#do connection, select one user from database
	@getSingleUser = (id, res) ->
		connection.acquire (err, con) ->
			con.query 'SELECT * FROM users WHERE id = ?', [id], (err, result) ->
				con.release()
				res.send result
				return
			return
		return
	#do connection, insert user data into database
	@createUser = (user, res) ->
		connection.acquire (err, con) ->
			con.query 'INSERT INTO users (first_name, last_name, email, user_type, colour, age, date_created) VALUES (?, ?, ?, ?, ?, ?, ?)',
			[user.first_name, user.last_name, user.email, user.user_type, user.colour, user.age, user.date_created], (err, result) ->
				con.release()
				#error check if succesful query or not
				if err
					return res.status(403).send(
						success: false
						message: 'failed creating user')
				else
					res.send
						success: true
						message: 'user created successfully'
				return
			return
		return

	#update
	#do connection, update user data item with id
	@updateUser = (user, id, res) ->
		connection.acquire (err, con) ->
			con.query 'UPDATE users SET first_name = ?, last_name = ?, email = ?, user_type = ?, colour = ?, age = ? WHERE id = ?',
			[user.first_name, user.last_name, user.email, user.user_type, user.colour, user.age, id], (err, result) ->
				con.release()
				#error check if successful query or not
				if err
					return res.status(403).send(
						success: false
						message: 'user update failed')
				else
					res.send
						success: true
						message: 'user updated successfully'
				return
			return
		return

	#delete
	#do connection, delete user data with id
	@deleteUser = (id, res) ->
		connection.acquire (err, con) ->
			con.query 'DELETE FROM users WHERE id = ?', [id], (err, result) ->
				con.release()
				#error check if successful query or not
				if err
					return res.status(403).send(
						success: false
						message: 'failed deleting user')
				else
					res.send
						success: true
						message: 'user deleted successfully'
				return
			return
		return
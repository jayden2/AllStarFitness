jwt = require 'jsonwebtoken'
bcrypt = require 'bcrypt-nodejs'
connection = require '../config/connection'
secretPassword = 'superSpecialSecretPasswordThatNooneWouldEverGuess123@#$%^&^$'

module.exports = class User
	#get all users
	#do connection, select all from users
	@getAllUsers = (res) ->
		connection.acquire (err, con) ->
			con.query 'SELECT id, first_name, last_name, email, user_type, gender, age, date_created, date_updated FROM users', (err, result) ->
				con.release()
				res.send result
				return
			return
		return
	#get one user
	#do connection, select one user from database
	@getSingleUser = (id, res) ->
		connection.acquire (err, con) ->
			con.query 'SELECT id, first_name, last_name, email, user_type, gender, age, date_created, date_updated FROM users WHERE id = ?', [id], (err, result) ->
				con.release()
				res.send result
				return
			return
		return
	#check if email already exists when we create a user
	#do connection, count users from database who have that username
	@checkValidEmail = (email, res) ->
		connection.acquire (err, con) ->
			con.query 'SELECT COUNT(id) AS user_count FROM users WHERE email = ?', [email], (err, result) ->
				con.release()
				res.send result
				return
			return
		return
	#check if user exists when a user tries to login
	#do connection, count if user exists
	@checkValidUser = (user, res) ->
		connection.acquire (err, con) ->
			con.query 'SELECT *, COUNT(id) AS user_count FROM users WHERE email = ? AND user_type = ?', [user.email, 'admin'], (err, result) ->
				con.release()
				#if username doesnt exist, dont auth
				if result[0].user_count != 1
					res.send
						success: false
						message: 'Authentication failed. User not found.'
				else if result[0].user_count == 1
					#if password doesnt match, dont auth
					if !bcrypt.compareSync user.password, result[0].password
						res.send
							success: false
							message: 'Authentication failed. Wrong password.'
					else
						#create token that expires in 7 days
						token = jwt.sign(user, secretPassword, expiresIn: '7 days')
						#send token to user
						res.send
							success: true
							message: 'Token Get!',
							id: result[0].id,
							email: result[0].email,
							first_name: result[0].first_name,
							last_name: result[0].last_name,
							token: token
				return
			return
		return
	@verifyUser = (req, res, next) ->
		#log api request
		console.log 'API Accessed.'
		#store token, and get it from where it was sent from
		token = req.body.token || req.query.token || req.headers['x-access-token']
		#decode token
		if token
			jwt.verify token, secretPassword, (err, decode) ->
				if err
					#if token password is out of date or is incorrect then send authentication failure
					return res.status(403).send(
						success: false
						message: 'Session Expired. Please Login Again!')
				else
					#if token verified save to request for use in other routes
					req.decode = decode
					next()
				return
		else
			#if no token was sent
			return res.status(403).send(
				success: false
				message: 'No token given. Please send request with a token.')
		return
	#do connection, insert user data into database
	@createUser = (user, res) ->
		pwd = hashPassword(user.password)
		connection.acquire (err, con) ->
			con.query 'INSERT INTO users (first_name, last_name, email, user_type, password, gender, age, date_created) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
			[user.first_name, user.last_name, user.email, user.user_type, pwd, user.gender, user.age, user.date_created], (err, result) ->
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
		pwd = hashPassword(user.password)
		connection.acquire (err, con) ->
			con.query 'UPDATE users SET first_name = ?, last_name = ?, email = ?, user_type = ?, password = ?, gender = ?, age = ? WHERE id = ?',
			[user.first_name, user.last_name, user.email, user.user_type, pwd, user.gender, user.age, id], (err, result) ->
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

	#create hash
	hashPassword = (pwd) ->
		hash = bcrypt.hashSync pwd
		return hash
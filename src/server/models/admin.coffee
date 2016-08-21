connection = require '../config/connection'
require('dotenv').config()
jwt = require 'jsonwebtoken'
bcrypt = require 'bcrypt-nodejs'
secretPassword = process.env.SUPRER_SECRET

module.exports = class Admin

	#check if email already exists when we create a admin
	#do connection, count admins from database who have that username
	@checkValidEmail = (email, res) ->
		connection.acquire (err, con) ->
			con.query 'SELECT COUNT(id) AS user_count FROM admin WHERE email = ?', [email], (err, result) ->
				con.release()
				res.send result
				return
			return
		return
	
	#check if admin exists when a user tries to login
	#do connection, count if user exists
	@checkValidAdmin = (user, res) ->
		connection.acquire (err, con) ->
			con.query 'SELECT *, COUNT(id) AS user_count FROM admin WHERE email = ? AND user_type = ?', [user.email, 'admin'], (err, result) ->
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
	
	@verifyAdmin = (req, res, next) ->
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

	#get one admin
	#do connection, select one admin from database
	@getSingleAdmin = (id, res) ->
		connection.acquire (err, con) ->
			con.query 'SELECT * FROM admin WHERE id = ?', [id], (err, result) ->
				con.release()
				res.send result
				return
			return
		return

	#do connection, insert admin data into database
	@createAdmin = (admin, res) ->
		pwd = hashPassword(admin.password)
		connection.acquire (err, con) ->
			con.query 'INSERT INTO admin (first_name, last_name, email, password, user_type, date_created) VALUES (?, ?, ?, ?, ?, ?)',
			[admin.first_name, admin.last_name, admin.email, pwd, admin.user_type, admin.date_created], (err, result) ->
				con.release()
				#error check if succesful query or not
				if err
					return res.status(403).send(
						success: false
						message: 'failed creating admin')
				else
					res.send
						success: true
						message: 'admin created successfully'
				return
			return
		return

	#create hash
	hashPassword = (pwd) ->
		hash = bcrypt.hashSync pwd
		return hash
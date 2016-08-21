connection = require '../config/connection'
cloudinary = require('cloudinary')
fs = require('fs')
require('dotenv').config()

#cloud connection
cloudinary.config
	cloud_name: process.env.CLOUD_NAME
	api_key: process.env.CLOUD_API_KEY
	api_secret: process.env.CLOUD_API_SECRET

module.exports = class Exercise
	#get all exercises
	#do connection, select all from exercises
	@getAllExercises = (res) ->
		connection.acquire (err, con) ->
			con.query 'SELECT * FROM exercises', (err, result) ->
				con.release()
				res.send result
				return
			return
		return

	#get one exercise
	#do connection, select one exercise from database
	@getSingleExercise = (id, res) ->
		connection.acquire (err, con) ->
			con.query 'SELECT * FROM exercises WHERE id = ?', [id], (err, result) ->
				con.release()
				res.send result
				return
			return
		return

	#get multiple exercises based on array
	#do connection, select one exercise from database
	@getMultipleExercises = (collection, res) ->
		connection.acquire (err, con) ->
			con.query 'SELECT * FROM exercises WHERE id IN (' + collection.selection + ')', (err, result) ->
				con.release()
				res.send result
				return
			return
		return

	#get one exercise --SHORT
	#do connection, select one exercise from database
	@getSingleExerciseShort = (id, res) ->
		connection.acquire (err, con) ->
			con.query 'SELECT id, title, favourite FROM exercises WHERE id = ?', [id], (err, result) ->
				con.release()
				res.send result
				return
			return
		return

	#do connection, insert exercise data into database
	@createExercise = (exercise, res) ->
		connection.acquire (err, con) ->
			con.query 'INSERT INTO exercises (title, description, image, duplicated, rep_time, def_set_start, def_set_end, def_rep_start, def_rep_end, date_created, favourite) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);',
			[exercise.title, exercise.description, exercise.image, exercise.duplicated, exercise.rep_time, exercise.def_set_start, exercise.def_set_end, exercise.def_rep_start, exercise.def_rep_end, exercise.date_created, exercise.favourite], (err, result) ->
				#error check if succesful query or not
				if err
					return res.status(403).send(
						success: false
						message: 'failed creating exercise')
				else
					con.query 'SELECT LAST_INSERT_ID() as return_id', (err, result) ->
						con.release()
						res.send
							return_id: result[0].return_id
							success: true
							message: 'exercise created successfully'
						return
					return
				return
			return
		return

	#file upload
	@uploadImage = (req, res) ->
		cloudinary.v2.uploader.upload req.file.path, { folder: '/allstarfitness' }, (error, result) ->
			fs.unlink('./' + req.file.path)
			res.send result

	#delete file
	@deleteImage = (file, res) ->
		path = 'allstarfitness/' + file.image
		cloudinary.uploader.destroy path, (result) ->
			res.send result

	#update
	#do connection, update workout data item with id
	@updateExercise = (exercise, id, res) ->
		connection.acquire (err, con) ->
			con.query 'UPDATE exercises SET title = ?, description = ?, image = ?, rep_time = ?, def_set_start = ?, def_set_end = ?, def_rep_start = ?, def_rep_end = ?, favourite = ? WHERE id = ?',
			[exercise.title, exercise.description, exercise.image, exercise.rep_time, exercise.def_set_start, exercise.def_set_end, exercise.def_rep_start, exercise.def_rep_end, exercise.favourite, id], (err, result) ->
				con.release()
				#error check if successful query or not
				if err
					return res.status(403).send(
						success: false
						message: 'exercise update failed')
				else
					res.send
						success: true
						message: 'exercise updated successfully'
				return
			return
		return

	#update
	#do connection, update exercise data item with id
	@updateExerciseFavourite = (exercise, id, res) ->
		connection.acquire (err, con) ->
			con.query 'UPDATE exercises SET favourite = ? WHERE id = ?',
			[exercise.favourite, id], (err, result) ->
				con.release()
				#error check if successful query or not
				if err
					return res.status(403).send(
						success: false
						message: 'exercise favourite update failed')
				else
					res.send
						success: true
						message: 'exercise favourite updated successfully'
				return
			return
		return

	#delete
	#do connection, delete exercise data with id
	@deleteExercise = (id, res) ->
		connection.acquire (err, con) ->
			con.query 'DELETE FROM exercises WHERE id = ?', [id], (err, result) ->
				con.release()
				#error check if successful query or not
				if err
					return res.status(403).send(
						success: false
						message: 'failed deleting exercise')
				else
					res.send
						success: true
						message: 'exercise deleted successfully'
				return
			return
		return
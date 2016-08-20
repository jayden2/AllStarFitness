connection = require '../config/connection'

module.exports = class Workout
	#get all workouts
	#do connection, select all from workouts
	@getAllWorkouts = (res) ->
		connection.acquire (err, con) ->
			con.query 'SELECT workouts.*, users.first_name, users.last_name, users.colour FROM workouts LEFT JOIN users on users.id = workouts.user_id', (err, result) ->
				con.release()
				res.send result
				return
			return
		return

	#get one workout
	#do connection, select one workout from database
	@getSingleWorkout = (id, res) ->
		connection.acquire (err, con) ->
			con.query 'SELECT workouts.*, users.first_name, users.last_name, users.colour FROM workouts LEFT JOIN users on users.id = workouts.user_id WHERE workouts.id = ?', [id], (err, result) ->
				con.release()
				res.send result
				return
			return
		return

	#get one workout --SHORT
	#do connection, select one workout from database
	@getSingleWorkoutShort = (id, res) ->
		connection.acquire (err, con) ->
			con.query 'SELECT id, title, collection, template FROM workouts WHERE id = ?', [id], (err, result) ->
				con.release()
				res.send result
				return
			return
		return

	#do connection, insert workout data into database
	@createWorkout = (workout, res) ->
		connection.acquire (err, con) ->
			con.query 'INSERT INTO workouts (title, collection, user_id, template, date_created) VALUES (?, ?, ?, ?, ?)',
			[workout.title, workout.collection, workout.user_id, workout.template, workout.date_created], (err, result) ->
				con.release()
				#error check if succesful query or not
				if err
					return res.status(403).send(
						success: false
						message: 'failed creating workout')
				else
					res.send
						success: true
						message: 'workout created successfully'
				return
			return
		return

	#update
	#do connection, update workout data item with id
	@updateWorkout = (workout, id, res) ->
		connection.acquire (err, con) ->
			con.query 'UPDATE workouts SET title = ?, collection = ?, user_id = ?, template = ? WHERE id = ?',
			[workout.title, workout.collection, workout.user_id, workout.template, id], (err, result) ->
				con.release()
				#error check if successful query or not
				if err
					return res.status(403).send(
						success: false
						message: 'workout update failed')
				else
					res.send
						success: true
						message: 'workout updated successfully'
				return
			return
		return

	#update
	#do connection, update workout data item with id
	@updateWorkoutTemplate = (workout, id, res) ->
		connection.acquire (err, con) ->
			con.query 'UPDATE workouts SET template = ? WHERE id = ?',
			[workout.template, id], (err, result) ->
				con.release()
				#error check if successful query or not
				if err
					return res.status(403).send(
						success: false
						message: 'workout update failed')
				else
					res.send
						success: true
						message: 'workout updated successfully'
				return
			return
		return

	#update
	#do connection, update workout collection data based on id
	@updateWorkoutCollection = (workout, id, res) ->
		connection.acquire (err, con) ->
			con.query 'UPDATE workouts SET collection = ? WHERE id = ?',
			[workout.collection, id], (err, result) ->
				con.release()
				#error check if successful query or not
				if err
					return res.status(403).send(
						success: false
						message: 'workout update failed')
				else
					res.send
						success: true
						message: 'workout updated successfully'
				return
			return
		return

	#delete
	#do connection, delete workout data with id
	@deleteWorkout = (id, res) ->
		connection.acquire (err, con) ->
			con.query 'DELETE FROM workouts WHERE id = ?', [id], (err, result) ->
				con.release()
				#error check if successful query or not
				if err
					return res.status(403).send(
						success: false
						message: 'failed deleting workout')
				else
					res.send
						success: true
						message: 'workout deleted successfully'
				return
			return
		return
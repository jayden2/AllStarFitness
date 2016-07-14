connection = require '../config/connection'

module.exports = class Workout
	#get all workouts
	#do connection, select all from workouts
	@getAllWorkouts = (res) ->
		connection.acquire (err, con) ->
			con.query 'SELECT * FROM workouts', (err, result) ->
				con.release()
				res.send result
				return
			return
		return

	#get one workout
	#do connection, select one workout from database
	@getSingleWorkout = (id, res) ->
		connection.acquire (err, con) ->
			con.query 'SELECT * FROM workouts WHERE id = ?', [id], (err, result) ->
				con.release()
				res.send result
				return
			return
		return

	#get one workout --SHORT
	#do connection, select one workout from database
	@getSingleWorkoutShort = (id, res) ->
		connection.acquire (err, con) ->
			con.query 'SELECT id, title, favourite FROM workouts WHERE id = ?', [id], (err, result) ->
				con.release()
				res.send result
				return
			return
		return

	#do connection, insert workout data into database
	@createWorkout = (workout, res) ->
		connection.acquire (err, con) ->
			con.query 'INSERT INTO workouts (title, description, image, def_set_start, def_set_end, def_rep_start, def_rep_end, date_created, favourite) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
			[workout.title, workout.description, workout.image, workout.def_set_start, workout.def_set_end, workout.def_rep_start, workout.def_rep_end, workout.date_created, workout.favourite], (err, result) ->
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
			con.query 'UPDATE workouts SET title = ?, description = ?, image = ?, def_set_start = ?, def_set_end = ?, def_rep_start = ?, def_rep_end = ?, favourite = ? WHERE id = ?',
			[workout.title, workout.description, workout.image, workout.def_set_start, workout.def_set_end, workout.def_rep_start, workout.def_rep_end, workout.favourite, id], (err, result) ->
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
	@updateWorkoutFavourite = (workout, id, res) ->
		connection.acquire (err, con) ->
			con.query 'UPDATE workouts SET favourite = ? WHERE id = ?',
			[workout.favourite, id], (err, result) ->
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
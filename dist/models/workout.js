var Workout, connection;

connection = require('../config/connection');

module.exports = Workout = (function() {
  function Workout() {}

  Workout.getAllWorkouts = function(res) {
    connection.acquire(function(err, con) {
      con.query('SELECT * FROM workouts', function(err, result) {
        con.release();
        res.send(result);
      });
    });
  };

  Workout.getSingleWorkout = function(id, res) {
    connection.acquire(function(err, con) {
      con.query('SELECT * FROM workouts WHERE id = ?', [id], function(err, result) {
        con.release();
        res.send(result);
      });
    });
  };

  Workout.getSingleWorkoutShort = function(id, res) {
    connection.acquire(function(err, con) {
      con.query('SELECT id, title, favourite FROM workouts WHERE id = ?', [id], function(err, result) {
        con.release();
        res.send(result);
      });
    });
  };

  Workout.createWorkout = function(workout, res) {
    connection.acquire(function(err, con) {
      con.query('INSERT INTO workouts (title, description, image, def_set_start, def_set_end, def_rep_start, def_rep_end, date_created, favourite) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', [workout.title, workout.description, workout.image, workout.def_set_start, workout.def_set_end, workout.def_rep_start, workout.def_rep_end, workout.date_created, workout.favourite], function(err, result) {
        con.release();
        if (err) {
          return res.status(403).send({
            success: false,
            message: 'failed creating workout'
          });
        } else {
          res.send({
            success: true,
            message: 'workout created successfully'
          });
        }
      });
    });
  };

  Workout.updateWorkout = function(workout, id, res) {
    connection.acquire(function(err, con) {
      con.query('UPDATE workouts SET title = ?, description = ?, image = ?, def_set_start = ?, def_set_end = ?, def_rep_start = ?, def_rep_end = ?, favourite = ? WHERE id = ?', [workout.title, workout.description, workout.image, workout.def_set_start, workout.def_set_end, workout.def_rep_start, workout.def_rep_end, workout.favourite, id], function(err, result) {
        con.release();
        if (err) {
          return res.status(403).send({
            success: false,
            message: 'workout update failed'
          });
        } else {
          res.send({
            success: true,
            message: 'workout updated successfully'
          });
        }
      });
    });
  };

  Workout.updateWorkoutFavourite = function(workout, id, res) {
    connection.acquire(function(err, con) {
      con.query('UPDATE workouts SET favourite = ? WHERE id = ?', [workout.favourite, id], function(err, result) {
        con.release();
        if (err) {
          return res.status(403).send({
            success: false,
            message: 'workout update failed'
          });
        } else {
          res.send({
            success: true,
            message: 'workout updated successfully'
          });
        }
      });
    });
  };

  Workout.deleteWorkout = function(id, res) {
    connection.acquire(function(err, con) {
      con.query('DELETE FROM workouts WHERE id = ?', [id], function(err, result) {
        con.release();
        if (err) {
          return res.status(403).send({
            success: false,
            message: 'failed deleting workout'
          });
        } else {
          res.send({
            success: true,
            message: 'workout deleted successfully'
          });
        }
      });
    });
  };

  return Workout;

})();

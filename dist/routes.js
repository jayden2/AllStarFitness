var user, workout;

user = require('./models/user');

workout = require('./models/workout');

module.exports = {
  configure: function(app, router) {
    router.get('/', function(req, res) {
      return res.json({
        message: 'AllStarFitness API up and running! What would you like sir?'
      });
    });
    router.post('/authenticate/', function(req, res) {
      return user.checkValidUser(app, req.body, res);
    });
    router.get('/users/:email/check/', function(req, res) {
      return user.checkValidEmail(req.params.email, res);
    });
    router.use(function(req, res, next) {
      return user.verifyUser(req, res, next);
    });
    router.post('/users/', function(req, res) {
      return user.createUser(req.body, res);
    });
    router.get('/users/', function(req, res) {
      return user.getAllUsers(res);
    });
    router.get('/users/:id/', function(req, res) {
      return user.getSingleUser(req.params.id, res);
    });
    router.put('/users/:id/', function(req, res) {
      return user.updateUser(req.body, req.params.id, res);
    });
    router["delete"]('/users/:id/', function(req, res) {
      return user.deleteUser(req.params.id, res);
    });
    router.post('/workouts/', function(req, res) {
      return workout.createWorkout(req.body, res);
    });
    router.get('/workouts/', function(req, res) {
      return workout.getAllWorkouts(res);
    });
    router.get('/workouts/:id/', function(req, res) {
      return workout.getSingleWorkout(req.params.id, res);
    });
    router.get('/workouts/:id/short', function(req, res) {
      return workout.getSingleWorkoutShort(req.params.id, res);
    });
    router.put('/workouts/:id/', function(req, res) {
      return workout.updateWorkout(req.body, req.params.id, res);
    });
    router.put('/workouts/:id/favourite', function(req, res) {
      return workout.updateWorkoutFavourite(req.body, req.params.id, res);
    });
    router["delete"]('/workouts/:id/', function(req, res) {
      return workout.deleteWorkout(req.params.id, res);
    });
    return app.use('/api', router);
  }
};

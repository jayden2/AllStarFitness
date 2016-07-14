var doc, user, workout;

user = require('./models/user');

workout = require('./models/workout');

doc = require('./models/document');

module.exports = {
  configure: function(app, router) {
    router.get('/api', function(req, res) {
      return res.json({
        message: 'AllStarFitness API up and running! What would you like sir?'
      });
    });
    router.post('/api/authenticate/', function(req, res) {
      return user.checkValidUser(app, req.body, res);
    });
    router.get('/api/users/:email/check/', function(req, res) {
      return user.checkValidEmail(req.params.email, res);
    });
    router.get('/health', function(req, res) {
      res.writeHead(200);
      return res.end();
    });
    router.use(function(req, res, next) {
      return user.verifyUser(req, res, next);
    });
    router.post('/api/users/', function(req, res) {
      return user.createUser(req.body, res);
    });
    router.get('/api/users/', function(req, res) {
      return user.getAllUsers(res);
    });
    router.get('/api/users/:id/', function(req, res) {
      return user.getSingleUser(req.params.id, res);
    });
    router.put('/api/users/:id/', function(req, res) {
      return user.updateUser(req.body, req.params.id, res);
    });
    router["delete"]('/api/users/:id/', function(req, res) {
      return user.deleteUser(req.params.id, res);
    });
    router.post('/api/workouts/', function(req, res) {
      return workout.createWorkout(req.body, res);
    });
    router.get('/api/workouts/', function(req, res) {
      return workout.getAllWorkouts(res);
    });
    router.get('/api/workouts/:id/', function(req, res) {
      return workout.getSingleWorkout(req.params.id, res);
    });
    router.get('/api/workouts/:id/short', function(req, res) {
      return workout.getSingleWorkoutShort(req.params.id, res);
    });
    router.put('/api/workouts/:id/', function(req, res) {
      return workout.updateWorkout(req.body, req.params.id, res);
    });
    router.put('/api/workouts/:id/favourite', function(req, res) {
      return workout.updateWorkoutFavourite(req.body, req.params.id, res);
    });
    router["delete"]('/api/workouts/:id/', function(req, res) {
      return workout.deleteWorkout(req.params.id, res);
    });
    router.post('/api/documents/', function(req, res) {
      return doc.createDocument(req.body, res);
    });
    router.get('/api/documents/', function(req, res) {
      return doc.getAllDocuments(res);
    });
    router.get('/api/documents/:id/', function(req, res) {
      return doc.getSingleDocument(req.params.id, res);
    });
    router.get('/api/documents/:id/short', function(req, res) {
      return doc.getSingleDocumentShort(req.params.id, res);
    });
    router.put('/api/documents/:id/', function(req, res) {
      return doc.updateDocument(req.body, req.params.id, res);
    });
    router.put('/api/documents/:id/template', function(req, res) {
      return doc.updateDocumentTemplate(req.body, req.params.id, res);
    });
    router["delete"]('/api/documents/:id/', function(req, res) {
      return doc.deleteDocument(req.params.id, res);
    });
    return app.use(router);
  }
};

var exercise,user,workout;user=require("./server/models/user"),exercise=require("./server/models/exercise"),workout=require("./server/models/workout"),module.exports=function(e){return e.get("/api",function(e,r){return r.json({message:"AllStarFitness API up and running! What would you like sir?"})}),e.post("/api/authenticate/",function(e,r){return user.checkValidUser(e.body,r)}),e.get("/api/users/:email/check/",function(e,r){return user.checkValidEmail(e.params.email,r)}),e.get("/health",function(e,r){return r.writeHead(200),r.end()}),e.use("/api/",function(e,r,t){return user.verifyUser(e,r,t)}),e.post("/api/users/",function(e,r){return user.createUser(e.body,r)}),e.get("/api/users/",function(e,r){return user.getAllUsers(r)}),e.get("/api/users/:id/",function(e,r){return user.getSingleUser(e.params.id,r)}),e.put("/api/users/:id/",function(e,r){return user.updateUser(e.body,e.params.id,r)}),e["delete"]("/api/users/:id/",function(e,r){return user.deleteUser(e.params.id,r)}),e.post("/api/exercises/",function(e,r){return exercise.createExercise(e.body,r)}),e.post("/api/exercises/image/",function(e,r){return exercise.uploadImage(e.body,r)}),e.get("/api/exercises/",function(e,r){return exercise.getAllExercises(r)}),e.get("/api/exercises/:id/",function(e,r){return exercise.getSingleExercise(e.params.id,r)}),e.get("/api/exercises/:id/short/",function(e,r){return exercise.getSingleExerciseShort(e.params.id,r)}),e.put("/api/exercises/:id/",function(e,r){return exercise.updateExercise(e.body,e.params.id,r)}),e.put("/api/exercises/:id/favourite/",function(e,r){return exercise.updateExerciseFavourite(e.body,e.params.id,r)}),e["delete"]("/api/exercises/:id/",function(e,r){return exercise.deleteExercise(e.params.id,r)}),e.post("/api/workouts/",function(e,r){return workout.createWorkout(e.body,r)}),e.get("/api/workouts/",function(e,r){return workout.getAllWorkouts(r)}),e.get("/api/workouts/:id/",function(e,r){return workout.getSingleWorkout(e.params.id,r)}),e.get("/api/workouts/:id/short",function(e,r){return workout.getSingleWorkoutShort(e.params.id,r)}),e.put("/api/workouts/:id/",function(e,r){return workout.updateWorkout(e.body,e.params.id,r)}),e.put("/api/workouts/:id/template/",function(e,r){return workout.updateWorkoutTemplate(e.body,e.params.id,r)}),e["delete"]("/api/workouts/:id/",function(e,r){return workout.deleteWorkout(e.params.id,r)}),e.get("*",function(e,r){return r.sendFile(__dirname+"/client/index.html")})};
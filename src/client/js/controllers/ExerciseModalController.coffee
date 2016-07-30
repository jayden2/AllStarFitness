ExerciseModalController = ($scope, $uibModalInstance, ExerciseService, LoginService, type, exercise) ->
	
	#ititialise variables
	$scope.type = type
	savedExercise = angular.copy(exercise)
	$scope.exercise = exercise
	$scope.loading = false
	currentUser = LoginService.getUserInfo()

	#title of modal
	chooseModalType = ->
		if type == "create"
			$scope.title = "Create Exercise"
			$scope.buttonSave = "Create Exercise"
			$scope.buttonDelete = false
		else
			$scope.title = "Edit Exercise"
			$scope.buttonSave = "Save Exercise"
			$scope.buttonDelete = true

	#close modal delete
	$scope.delete = ->
		$scope.deleteExercise()
		$uibModalInstance.close('postupdel')

	#close modal cancel
	$scope.cancel = ->
		$scope.exercise.title = savedExercise.title
		$uibModalInstance.dismiss('cancel')

	$scope.setFile = (element) ->
		$scope.currentFile = element.files[0]
		console.log $scope.currentFile
		reader = new FileReader

		reader.onload = (event) ->
			$scope.image_source = event.target.result
			$scope.$apply()
			return

		# when the file is read it triggers the onload event above.
		reader.readAsDataURL element.files[0]
		return
	
	#upload image
	$scope.uploadImage = ->
		path = $('#trigger').val().replace(/\\/g,"/")
		if $scope.loading == false
			$scope.loading = true
			ExerciseService.uploadImage(path, currentUser.token).then ((result) ->
				console.log result
				$scope.loading = false
			), (error) ->
				console.log error
				$scope.loading = false
				return
		return


	#delete exercise
	$scope.deleteExercise = ->
		if $scope.loading == false
			$scope.loading = true
			loadingCall(true)
			ExerciseService.deleteExercise($scope.exercise.id, currentUser.token).then ((result) ->
				$scope.exercises = result
				$scope.loading = false
				loadingCall(false)
			), (error) ->
				console.log error
				$scope.loading = false
				loadingCall(false)
				return
		return

	chooseModalType()
	return

angular.module('AllStarFitness')
	.controller 'ExerciseModalController', [
		'$scope'
		'$uibModalInstance'
		'ExerciseService'
		'LoginService'
		'type'
		'exercise'
		ExerciseModalController
	]
ExerciseModalController = ($scope, $uibModalInstance, ExerciseService, LoginService, type, exercise) ->
	
	#ititialise variables
	$scope.type = type
	savedExercise = angular.copy(exercise)
	$scope.loading = false
	$scope.exercise = { }
	currentUser = LoginService.getUserInfo()
	$.cloudinary.config
		cloud_name: 'jayden159'
		api_key: '733379363423251'

	console.log exercise


	#title of modal
	chooseModalType = ->
		if type == "create"
			$scope.title = "Create Exercise"
			$scope.buttonSave = "Create Exercise"
			$scope.buttonDelete = false
			$scope.exercise.def_rep_start = 1
			$scope.exercise.def_rep_end = 1
			$scope.exercise.def_set_start = 1
			$scope.exercise.def_set_end = 1
		else
			$scope.exercise = exercise
			$scope.title = "Edit Exercise"
			$scope.buttonSave = "Save Exercise"
			$scope.buttonDelete = true

	$scope.repStartPlus = ->
		if parseInt($scope.exercise.def_rep_start, 10) and $scope.exercise.def_rep_start < 100 then $scope.exercise.def_rep_start++

	$scope.repStartMinus = ->
		if parseInt($scope.exercise.def_rep_start, 10) and $scope.exercise.def_rep_start > 1 then $scope.exercise.def_rep_start--

	$scope.repEndPlus = ->
		if parseInt($scope.exercise.def_rep_end, 10) and $scope.exercise.def_rep_end < 100 then $scope.exercise.def_rep_end++

	$scope.repEndMinus = ->
		if parseInt($scope.exercise.def_rep_end, 10) and $scope.exercise.def_rep_end > 1 then $scope.exercise.def_rep_end--

	$scope.setStartPlus = ->
		if parseInt($scope.exercise.def_set_start, 10) and $scope.exercise.def_set_start < 100 then $scope.exercise.def_set_start++

	$scope.setStartMinus = ->
		if parseInt($scope.exercise.def_set_start, 10) and $scope.exercise.def_set_start > 1 then $scope.exercise.def_set_start--

	$scope.setEndPlus = ->
		if parseInt($scope.exercise.def_set_end, 10) and $scope.exercise.def_set_end < 100 then $scope.exercise.def_set_end++

	$scope.setEndMinus = ->
		if parseInt($scope.exercise.def_set_end, 10) and $scope.exercise.def_set_end > 1 then $scope.exercise.def_set_end--

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
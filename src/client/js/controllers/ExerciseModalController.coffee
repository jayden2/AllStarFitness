ExerciseModalController = ($scope, $uibModalInstance, ExerciseService, LoginService, type, exercise) ->
	
	#ititialise variables
	$scope.type = type
	savedExercise = angular.copy(exercise)
	$scope.loading = false
	$scope.exercise = { }
	$scope.tempImage = null
	$scope.currentFile = null
	$scope.imageUploadMust = false
	$('#trigger').val('')
	currentUser = LoginService.getUserInfo()

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
			$scope.buttonDupilcate = false
		else if type == "editOnWorkout"
			$scope.exercise = exercise
			$scope.title = "Edit Exercise"
			$scope.buttonSave = "Save Exercise"
			$scope.buttonDelete = false
			$scope.buttonDupilcate = true
		else
			$scope.exercise = exercise
			$scope.title = "Edit Exercise"
			$scope.buttonSave = "Save Exercise"
			$scope.buttonDelete = true
			$scope.buttonDupilcate = false

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

		#check
		if $scope.imageUploadMust == true
			formError("Please remove the uploaded image, before you delete!")
			return

		if !isNullOrEmptyOrUndefined($scope.exercise.image)
			$scope.loading = true
			tempDel = $scope.exercise.image.split("/").pop()
			tempDel = tempDel.replace(/\.[^/.]+$/, "")
			ExerciseService.deleteImage(tempDel, currentUser.token).then ((result) ->
				console.log result
				$scope.exercise.image = null
				$scope.loading = false
				$scope.imageUploadMust = false
			), (error) ->
				console.log error
				$scope.loading = false

		$scope.deleteExercise()
		$uibModalInstance.close('postupdel')

	#close modal cancel
	$scope.cancel = ->

		if $scope.imageUploadMust == true
			formError("Please remove the uploaded image before you cancel")
			return

		$scope.tempImage = null
		$scope.currentFile = null
		$scope.exercise.title = savedExercise.title
		$scope.exercise.image = savedExercise.image
		$scope.exercise.description = savedExercise.description
		$scope.exercise.def_rep_start = savedExercise.def_rep_start
		$scope.exercise.def_rep_end = savedExercise.def_rep_end
		$scope.exercise.def_set_start = savedExercise.def_set_start
		$scope.exercise.def_set_end = savedExercise.def_set_end
		$uibModalInstance.dismiss('cancel')

	$scope.confirm = ->
		
		if isNullOrEmptyOrUndefined($scope.exercise.title)
			formError("Title is empty")
			return

		if isNullOrEmptyOrUndefined($scope.exercise.image)
			$scope.exercise.image = ""

		if isNullOrEmptyOrUndefined($scope.exercise.description)
			$scope.exercise.description = ""

		if !isNullOrEmptyOrUndefined($scope.currentFile)
			formError("You have selected an image but have not uploaded it")
			return
		
		if type == "create"
			$scope.postExercise()
		else
			$scope.updateExercise()
		$uibModalInstance.close('postupdel')

	#browse set fill
	$scope.setFile = (element) ->
		$scope.currentFile = element.files[0]
		reader = new FileReader

		reader.onload = (event) ->
			$scope.tempImage = event.target.result
			$scope.$apply()
			return

		# when the file is read it triggers the onload event above.
		reader.readAsDataURL element.files[0]
		return
	
	#upload image
	$scope.uploadImage = (img) ->
		$scope.loading = true
		$scope.tempImage = null

		ExerciseService.uploadImage($scope.currentFile, currentUser.token).then ((result) ->			

			$scope.currentFile = null
			$('#trigger').val('')
			

			#if image already exists remove it
			if !isNullOrEmptyOrUndefined($scope.exercise.image)
				$scope.removeImage('newUpload')

			$scope.imageUploadMust = true
			$scope.exercise.image = result.secure_url
			$scope.loading = false
			loadingCall(false)
		), (error) ->
			console.log error
			$scope.loading = false
			loadingCall(false)
			return

		return

	#remove image
	$scope.removeImage = (from) ->
		if !isNullOrEmptyOrUndefined($scope.currentFile)
			$('#trigger').val('')
			$scope.currentFile = null
			$scope.tempImage = null
			$('.imagePreview').attr('src', '')
		else
			$scope.loading = true
			tempDel = $scope.exercise.image.split("/").pop()
			tempDel = tempDel.replace(/\.[^/.]+$/, "")
			ExerciseService.deleteImage(tempDel, currentUser.token).then ((result) ->
				console.log result
				if from == 'deletion'
					$scope.exercise.image = null
					$scope.loading = false
					$scope.imageUploadMust = false
			), (error) ->
				console.log error
				$scope.loading = false
		return

	#loading spinner if posts or not...
	loadingCall = (isLoading) ->
		loading_circle = "<i class='fa fa-cog fa-spin fa-lg'></i>"
		loading_text = "loading"
		if isLoading
			$scope.buttonSave = ""
			$('.login-button').append(loading_circle)
		else
			$('.fa-cog').remove()

	#display error on form if there is an error
	formError = (errorText) ->
		$('.alert').remove()
		error_message = "<div class='alert alert-danger alert-dismissible' role='alert'>" + errorText + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button></div>"
		$('form').prepend(error_message)

	#validate form
	isNullOrEmptyOrUndefined = (value) ->
		!value

	#post exercise
	$scope.postExercise = ->
		if $scope.loading == false
			$scope.loading = true
			loadingCall(true)
			ExerciseService.createExercise($scope.exercise, currentUser.token).then ((result) ->
				$scope.exercises = result
				$scope.loading = false
				loadingCall(false)
			), (error) ->
				console.log error
				$scope.loading = false
				loadingCall(false)
				return
		return

	#update exercise
	$scope.updateExercise = ->
		if $scope.loading == false
			$scope.loading = true
			loadingCall(true)
			ExerciseService.updateExercise($scope.exercise, $scope.exercise.id, currentUser.token).then ((result) ->
				$scope.exercises = result
				$scope.loading = false
				loadingCall(false)
			), (error) ->
				console.log error
				$scope.loading = false
				loadingCall(false)
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
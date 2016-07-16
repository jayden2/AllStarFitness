rdLoading = ->
	directive =
		transclude: true
		restrict: 'AE'
		templateUrl: 'js/directives/loading.html'
	directive

angular.module('AllStarFitness').directive 'rdLoading', rdLoading
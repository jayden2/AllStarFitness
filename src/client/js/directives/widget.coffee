rdWidget = ->
	directive =
		transclude: true
		restrict: 'EA'
		templateUrl: 'js/directives/widget.html'
		link: (scope, element, attrs) ->
			return
	directive

angular.module('AllStarFitness').directive 'rdWidget', rdWidget
rdWidgetBody = ->
	directive =
		requires: '^rdWidget'
		scope:
			loading: '@?'
			classes: '@?'
		transclude: true
		restrict: 'E'
		templateUrl: 'js/directives/widget-body.html'
	directive

angular.module('AllStarFitness').directive 'rdWidgetBody', rdWidgetBody
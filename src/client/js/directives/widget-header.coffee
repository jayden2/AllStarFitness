rdWidgetHeader = ->
	directive =
		requires: '^rdWidget'
		scope:
			title: '@'
			icon: '@'
		transclude: true
		restrict: 'E'
		templateUrl: 'js/directives/widget-header.html'
	directive

angular.module('AllStarFitness').directive 'rdWidgetHeader', rdWidgetHeader
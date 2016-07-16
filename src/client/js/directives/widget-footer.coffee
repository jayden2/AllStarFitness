rdWidgetFooter = ->
	directive =
		requires: '^rdWidget'
		transclude: true
		restrict: 'E'
		templateUrl: 'js/directives/widget-footer.html'
	directive

angular.module('AllStarFitness').directive 'rdWidgetFooter', rdWidgetFooter
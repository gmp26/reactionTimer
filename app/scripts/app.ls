'use strict'

angular.module 'reactionTimerApp', ['ngRoute', 'ngTouch']
  .config ($routeProvider) ->
    $routeProvider.when '/', {
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
    } .otherwise {
      redirectTo: '/'
    }


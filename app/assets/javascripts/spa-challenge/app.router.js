(function() {
  "use strict";

  angular
    .module("spa-challenge")
    .config(RouterFunction);

  RouterFunction.$inject = ["$stateProvider",
                            "$urlRouterProvider", 
                            "spa-challenge.config.APP_CONFIG"];

  function RouterFunction($stateProvider, $urlRouterProvider, APP_CONFIG) {

    $urlRouterProvider.otherwise("/signup");

    $stateProvider
    .state("home",{
      url: "/welcome",
      templateUrl: APP_CONFIG.welcome_page_html
    })
    .state("images",{
      url: "/images/:id",
      templateUrl: APP_CONFIG.images_page_html
    })
    .state("accountSignup",{
      url: "/signup",
      templateUrl: APP_CONFIG.signup_page_html
    })
    ; 
  }
})();

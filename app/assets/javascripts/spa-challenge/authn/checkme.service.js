(function() {
  "use strict";

  angular
    .module("spa-challenge.authn")
    .factory("spa-challenge.authn.checkMe", CheckMeFactory);

  CheckMeFactory.$inject = ["$resource", "spa-challenge.config.APP_CONFIG"];
  function CheckMeFactory($resource, APP_CONFIG) {
    return $resource(APP_CONFIG.server_url + "/authn/checkme");
  }
})();

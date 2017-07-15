(function() {
  "use strict";

  angular
    .module("spa-challenge.authn")
    .factory("spa-challenge.authn.whoAmI", WhoAmIFactory);

  WhoAmIFactory.$inject = ["$resource", "spa-challenge.config.APP_CONFIG"];
  function WhoAmIFactory($resource, APP_CONFIG) {
    return $resource(APP_CONFIG.server_url + "/authn/whoami");
  }
})();

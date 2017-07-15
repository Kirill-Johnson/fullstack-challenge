(function() {
  "use strict";

  angular
    .module("spa-challenge", [
      "ui.router",
      "ngFileUpload",
      "uiCropper",      
      "spa-challenge.config",
      "spa-challenge.authn",
      "spa-challenge.authz",
      "spa-challenge.images",
      "spa-challenge.layout",
    ]);
})();

(function() {
  "use strict";

  angular
    .module("spa-challenge.images")
    .factory("spa-challenge.images.ImagesAuthz", ImagesAuthzFactory);

  ImagesAuthzFactory.$inject = ["spa-challenge.authz.Authz",
                                "spa-challenge.authz.BasePolicy"];
  function ImagesAuthzFactory(Authz, BasePolicy) {
    function ImagesAuthz() {
      BasePolicy.call(this, "Image");
    }

      //start with base class prototype definitions
    ImagesAuthz.prototype = Object.create(BasePolicy.prototype);
    ImagesAuthz.constructor = ImagesAuthz;

      //override and add additional methods
    ImagesAuthz.prototype.canCreate=function() {
      //console.log("ItemsAuthz.canCreate");
      return Authz.isAuthenticated();
    };

    return new ImagesAuthz();
  }
})();

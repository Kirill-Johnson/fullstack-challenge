(function() {
  "use strict";

  angular
    .module("spa-challenge.images")
    .component("sdImageSelector", {
      templateUrl: imageSelectorTemplateUrl,
      controller: ImageSelectorController,
      bindings: {
        authz: "<"
      },
    })
    .component("sdImageEditor", {
      templateUrl: imageEditorTemplateUrl,
      controller: ImageEditorController,
      bindings: {
        authz: "<"
      },
      require: {
        imagesAuthz: "^sdImagesAuthz"
      }
    });


  imageSelectorTemplateUrl.$inject = ["spa-challenge.config.APP_CONFIG"];
  function imageSelectorTemplateUrl(APP_CONFIG) {
    return APP_CONFIG.image_selector_html;
  }    
  imageEditorTemplateUrl.$inject = ["spa-challenge.config.APP_CONFIG"];
  function imageEditorTemplateUrl(APP_CONFIG) {
    return APP_CONFIG.image_editor_html;
  }    

  ImageSelectorController.$inject = ["$scope",
                                     "$stateParams",
                                     "spa-challenge.authz.Authz",
                                     "spa-challenge.images.Image",
                                     "spa-challenge.authn.Authn"];
  function ImageSelectorController($scope, $stateParams, Authz, Image, Authn) {
    var vm=this;

    vm.getCurrentUser = Authn.getCurrentUser;

    vm.$onInit = function() {
      //console.log("ImageSelectorController",$scope);
      $scope.$watch(function(){ return Authz.getAuthorizedUserId(); }, 
                    function(){ 
                      if (!$stateParams.id) { 
                        vm.items = Image.query(); 
                      }
                    });
    }
    return;
    //////////////
  }


  ImageEditorController.$inject = ["$scope","$q",
                                   "$state", "$stateParams",
                                   "spa-challenge.authz.Authz",
                                   "spa-challenge.layout.DataUtils",
                                   "spa-challenge.images.Image"
                                   ];
  function ImageEditorController($scope, $q, $state, $stateParams, 
                                 Authz, DataUtils, Image, Authn) {
    var vm=this;
    vm.selected_linkables=[];
    vm.create = create;
    vm.clear  = clear;
    vm.update  = update;
    vm.remove  = remove;
    vm.setImageContent = setImageContent;

    vm.$onInit = function() {
      //console.log("ImageEditorController",$scope);
      $scope.$watch(function(){ return Authz.getAuthorizedUserId(); }, 
                    function(){ 
                      if ($stateParams.id) {
                        reload($stateParams.id);
                      } else {
                        newResource();
                      }
                    });
    }
    return;
    //////////////
    function newResource() {
      //console.log("newResource()");
      vm.item = new Image();
      vm.imagesAuthz.newItem(vm.item);
      return vm.item;
    }

    function reload(imageId) {
      var itemId = imageId ? imageId : vm.item.id;
      //console.log("re/loading image", itemId);
      vm.item = Image.get({id:itemId});
      vm.imagesAuthz.newItem(vm.item);
    }

    function clear() {
      if (!vm.item.id) {
        $state.reload();
      } else {
        $state.go(".", {id:null});
      }
    }

    function setImageContent(dataUri) {
      //console.log("setImageContent", dataUri ? dataUri.length : null);      
      vm.item.image_content = DataUtils.getContentFromDataUri(dataUri);
    }    

    function create() {
      vm.item.$save().then(
        function(){
           $state.go(".", {id: vm.item.id}); 
        },
        handleError);
    }

    function update() {
      vm.item.errors = null;
      var update=vm.item.$update().then(
        function(){
          reload();
        },
        handleError);
    }

    function remove() {
      vm.item.errors = null;
      vm.item.$delete().then(
        function(){ 
          //console.log("remove complete", vm.item);          
          clear();
        },
        handleError);      
    }

    function handleError(response) {
      console.log("error", response);
      if (response.data) {
        vm.item["errors"]=response.data.errors;          
      } 
      if (!vm.item.errors) {
        vm.item["errors"]={}
        vm.item["errors"]["full_messages"]=[response]; 
      }      
      $scope.imageform.$setPristine();
    }    
  }

})();

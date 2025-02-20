sap.ui.define([
    "sap/ui/core/mvc/Controller",
], (Controller) => {
    "use strict";

    return Controller.extend("project1.controller.View1", {
        onInit() {
            var oModel = this.getOwnerComponent().getModel("week");
        },
        onButtonPress: function () {
            sap.m.MessageToast.show("Butona tıkladın!");
        },
        onItemPress: function () {
            
            sap.m.MessageToast.show("İteme tıkladın!");

            
        }
    });
});
sap.ui.define([
    "sap/ui/core/mvc/Controller"
], function(Controller) {
    "use strict";

    return Controller.extend("project1.controller.Detail", {
        onInit: function() {
            // URL Parametrelerini al
            var oRouter = sap.ui.core.UIComponent.getRouterFor(this);
            oRouter.getRoute("details").attachPatternMatched(this.onPatternMatched, this);
        },

        onPatternMatched: function(oEvent) {
            // URL'deki parametreyi al
            var oArgs = oEvent.getParameter("arguments");
            var day = oArgs.day;  // Dinamik parametre

            // Seçilen günü ve görevi göster
            this.getView().bindElement({
                path: "/days/" + day, // JSON modeline bağlanma
                model: "week" // "week" modelini kullanıyoruz
            });
        }
    });
});

({
    closeAlertNotified : function(cmp, event) {
        //var toastEvent = $A.get("e.c:toastEvt");
        //toastEvent.fire();
        console.log("closeNotification");
        var closeNotification = cmp.getEvent("closeNotificationEvent");
        closeNotification.fire();
    }
})
({
    showToast : function(cmp, event, helper) {
        var action = event.getParam("action");
        var message = event.getParam("message");
        var time = event.getParam("time");
        //var type = event.getParam("type");
        var nextCmp;
        var attribute;
        /*if(type == 'prompt'){
            nextCmp = "promptCmp";
            attribute = {

            };
        }else{*/
            nextCmp = "toastCmp";
            attribute = {
                "action": action,
                "message": message,
                "time" : time
            };
        $A.createComponent(
            "c:"+nextCmp,
            attribute
            ,
            function(notification, status, errorMessage){

                if (status === "SUCCESS") {
                    var body = cmp.get("v.body");
                    body.push(notification);
                    cmp.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")

                }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);

                    }
            }
        );

    },
    closeNotification : function(cmp,event,helper){
        var body = cmp.get("v.body");
        console.log("body",body,body.length);
        if(body.length){
            console.log("body");
            body.splice(body.length-1, 1);
            cmp.set("v.body",body);
        }
    }
})
({
    createExamField : function(cmp,event,attrs,cmpName) {
        var uiCmps = [];

        var uiCmp = [
            cmpName,
            attrs
        ];

        uiCmps.push(uiCmp);
        this.createUiCmps(cmp,uiCmps);

    },
    createUiCmps : function(cmp,uiCmps) {
        console.log("uiCmps::::",uiCmps);
        var div = cmp.find("createCmp");
        console.log("div::::",div);
 		    div.set("v.body", []);
        $A.createComponents(uiCmps,
            function(components, status, errorMessage){
                console.log(":::::",status);
                if (status === "SUCCESS") {
                    div.set("v.body", components);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.");

                }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);

                    }
            }
        );
    },
})
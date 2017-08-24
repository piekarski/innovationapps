({
    generateSummary : function(cmp,event) {
        console.log("generateSummary");
        cmp.set("v.countQuestion",0);

        // window.ObjServiceComponent.getRecordById(cmp.get("v.assessementId"),function(ObjTemplate){
            // var ObjTempLength = ObjTemplates.length;
            // var countQuestion = cmp.get("v.countQuestion");

            // if(ObjTempLength > 0){
            //     for(var i = 0 ; i < ObjTempLength; i++){
            //         countQuestion += ObjTemplates[i].No_of_Questions_Obj__c;
            //     }
            // }
            //
            // console.log("count no of question in Obj",countQuestion);
            // cmp.set("v.countQuestion",countQuestion);
            var ObjTemplate = cmp.get("v.ObjTemplate")

            // cmp.set("v.ObjTemplate", ObjTemplate);



            var nextCmp = "ObjOptions"

            var attributes = {
                ObjTemplate: cmp.get("v.ObjTemplate"),
                fields: cmp.get("v.fields"),
                attachments : cmp.get("v.attachments"),
                ObjId : cmp.get("v.ObjTemplate").Id,
                isNew : cmp.get("v.isNew")
            };
            if(cmp.get("v.isNew")){
                cmp.set("v.isNew",false);
            }
            $A.createComponent(
                "c:" + nextCmp, attributes,
                function(retCmp, status, message) {
                    console.log(message);

                    var templateActions = cmp.find("templateActions");
                    var body = templateActions.get("v.body");
                    body.push(retCmp);
                    templateActions.set("v.body", body);
                    cmp.set("v.showSpinner",false);
                    //$A.util.addClass(cmpWizard, "slide-in");
                });


        // },function(error){
        //     console.log(":::::",error);
        // });


    },
    arrangeValue : function(cmp,event,helper,ObjContainFields){
        console.log(":::ObjContainFields::::", ObjContainFields.sobject[0]);

        cmp.set("v.ObjTemplate", ObjContainFields.sobject[0]);
        console.log(":::Attachment::::",ObjContainFields.attachment[0]);
        var attachment = ObjContainFields.attachment;
        if(attachment.length){
            cmp.set("v.attachments",attachment[0]);
        }
        helper.generateSummary(cmp, event);
    },
    showNotificationEvt : function(cmp,event,helper,status,message){
        var showNotificationEvent = $A.get("e.c:NotificationEvt");
        showNotificationEvent.setParams({
            "action" : status,
            "message" : message
        });
        showNotificationEvent.fire();
    },
    doInit : function(cmp, event, helper){
        var fieldSets = [];

        fieldSets.push("lightningCmp_BasicOptions_FieldSet");
        // fieldSets.push("lightningComp_BasicOptions_FieldSet");
        // fieldSets.push("lightningComp_AdvancedOptions_FieldSet");

        cmp.set("v.showNavTab", true);
        cmp.set("v.showSpinner", true);

        var params = {
            "sObjectName": "ExObj__IssueRequest_Life_Cycle__c",
            "fieldSets": fieldSets,
            "sObjectId": cmp.get("v.ObjId")
        };

        if (!cmp.get("v.fields")) {
            window.ObjServiceComponent.getRecordById(params,function(ObjContainFields){
                cmp.set("v.fields", ObjContainFields.fields);
                console.log("::::fields:",cmp.get("v.fields"));
                helper.arrangeValue(cmp,event,helper,ObjContainFields);

            },function(error){
                console.log(":::::",error);
            });

        }else {
            window.ObjServiceComponent.getRecord(params,function(ObjContainFields){
                helper.arrangeValue(cmp,event,helper,ObjContainFields);

            },function(error){
                console.log(":::::",error);
            });
        }


    }
})

({
    saveField : function(cmp, event, helper, value) {
        //cmp.set("v.showSpinner",true);
        var param = {
            "ObjectName" : cmp.get("v.sObjectName"),
            "id" : cmp.get("v.Id"),
            "fieldName" : cmp.get("v.fieldName"),
            "fieldVal" : value
        };

        var status,message;
        var fieldLabel = cmp.get("v.fieldLabel");
        if(param.ObjectName == 'Main_questionaire__c'){
            window.AssessmentServiceComponent.updateRecord(param, $A.getCallback(function(record){
                if(cmp.isValid()){
                    status = "success";
                    message = fieldLabel+" has been updated";
                    helper.showNotificationEvt(cmp,event,helper,status,message);
                    helper.updateFieldsEvt(cmp,event,helper,record);
                    //cmp.set("v.showSpinner",false);
                }

            }),null);
        }

        if(param.ObjectName == 'IssueRequest_Life_Cycle__c'){
            console.log("::  window.ObjServiceComponent:::",  window)
            window.ObjServiceComponent.updateRecord(param, $A.getCallback(function(record){
                if(cmp.isValid()){
                    status = "success";
                    message = fieldLabel+" has been updated";
                    helper.showNotificationEvt(cmp,event,helper,status,message);
                    helper.updateFieldsEvt(cmp,event,helper,record);
                    //cmp.set("v.showSpinner",false);
                }

            }),null);
        }

        if(param.ObjectName == 'Section_Template__c'){
            window.SectionServiceComponent.updateRecord(param, $A.getCallback(function(record){
                if(cmp.isValid()){
                    status = "success";
                    message = "Section name has been updated";
                    helper.showNotificationEvt(cmp,event,helper,status,message);
                    helper.updateFieldsEvt(cmp,event,helper,record);
                    //cmp.set("v.showSpinner",false);
                }

            }),null);

        }

        if(param.ObjectName == 'Question_Template__c'){

            window.QuestionServiceComponent.updateRecord(param, $A.getCallback(function(record){

                if(cmp.isValid()){
                    status = "success";
                    message = fieldLabel+" has been updated";
                    helper.showNotificationEvt(cmp,event,helper,status,message);
                    helper.updateFieldsEvt(cmp,event,helper,record);
                    //cmp.set("v.showSpinner",false);
                }

            }),null);
        }

        cmp.set("v.newValue",value);
        cmp.set("v.defaultMode",'view');
    },
    updateFieldsEvt : function(cmp,event,helper,record){
        var updateFields = cmp.getEvent("updateFields");
        updateFields.setParams({
            "sObject" : record
        });
        updateFields.fire();
    },

    showNotificationEvt : function(cmp,event,helper,status,message){
        var showNotificationEvent = $A.get("e.c:NotificationEvt");
        showNotificationEvent.setParams({
            "action" : status,
            "message" : message
        });
        showNotificationEvent.fire();
    },
    updateFieldValue : function(cmp,event,helper){

        var fieldLabel = cmp.get("v.fieldLabel");
        var status,message;
        var fileAttachment = cmp.find("fileAttachment");
        console.log("fileAttachment::::",fileAttachment);
        var fileContent = fileAttachment.get("v.fileContent");
        if(fileContent && Object.keys(fileContent).length){
            //cmp.set("v.showSpinner",true);
            fileAttachment.uploadToServer($A.getCallback(function(attachment){
                if(cmp.isValid()){
                    console.log(attachment);
                    cmp.set("v.attachment",attachment);
                    cmp.set("v.defaultMode","view");
                    status = "success";
                    message = fieldLabel+" has been updated";
                    helper.showNotificationEvt(cmp,event,helper,status,message);
                    //cmp.set("v.showSpinner",false);
                    var value = cmp.get("v.attachment").Name;

                    if(value){
                        var contentType = cmp.get("v.attachment").ContentType;
                        console.log("contentType");
                        contentType = contentType.split('/');
                        value = value+'.'+contentType[1];
                    }else{
                        value = "No file";
                    }

                    console.log("value:::",value);
                    cmp.set("v.value",value);
                }

            }));/*,function(response){
                var errors = response.getError();

                if (errors) {
                    status = "error";
                    message = fieldLabel+" has been updated";
                    helper.showNotificationEvt(cmp,event,helper,status,message);
                    cmp.set("v.showSpinner",false);
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                }

            });*/
        }
    }
})
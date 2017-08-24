({
    doInit : function(cmp, event, helper) {
        var type = cmp.get("v.valType");
        console.log("type::::",type);
        var cmpName;
        var attrs = {
            "fieldLabel" : cmp.get("v.fieldLabel"),
            "fieldName" : cmp.get("v.fieldName"),
            "record"  : cmp.getReference("v.record"),
            "Id" : cmp.get("v.Id"),
            "sObjectName" : cmp.get("v.sObjectAPI"),
            "editMode" : cmp.get("v.editMode"),
            "options" : cmp.get("v.options") || '',
            "attachment" : cmp.get("v.attachment") || '',
            "defaultMode" : cmp.get("v.defaultMode")
        };
        console.log("attr::::",attrs);
        console.log("type::::",type);
      if(type === "TEXTAREA" ){
            cmpName = "c:examTextArea";
            helper.createExamField(cmp,event,attrs,cmpName);
        }
        if(type === "STRING"){
            cmpName = "c:examTextFld";
            helper.createExamField(cmp,event,attrs,cmpName);
        }
        if(type === "BOOLEAN"){
            cmpName = "c:examCheckBoxFld";
            helper.createExamField(cmp,event,attrs,cmpName);
        }
        if(type === "URL"){
            cmpName = "c:examUrlFld";
            helper.createExamField(cmp,event,attrs,cmpName);
        }
        if(type === "PICKLIST" ){
            cmpName = "c:examPickListFld";
            helper.createExamField(cmp,event,attrs,cmpName);
        }
        if(type === "DOUBLE"){
            cmpName = "c:examDoubleFld";
            helper.createExamField(cmp,event,attrs,cmpName);
        }
        if(type === "CURRENCY"){
            cmpName = "c:examCurrencyFld";
            helper.createExamField(cmp,event,attrs,cmpName);
        }
        if(type === "PERCENT"){
            cmpName = "c:examPercentageFld";
            helper.createExamField(cmp,event,attrs,cmpName);

        }



    }
})
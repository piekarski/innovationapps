({
    doInit : function(cmp, event, helper) {
        console.log("options::",cmp.get("v.options"));
        if(!cmp.get("v.options")){
            var action = cmp.get("c.getPicklistValues");
            action.setParams({
                "ObjectApi_name" : cmp.get("v.sObjectName"),
                "Field_name" : cmp.get("v.fieldName")
            });
            action.setCallback(this,function(response){
                var status = response.getStatus();
                if(cmp.isValid() && status == "SUCCESS"){
                    var options = response.getReturnValue();
                    cmp.set("v.options",options);
                }else{
                    console.log("error::::::",response.getError());
                }
            });
            $A.enqueueAction(action);
        }
        var obj = cmp.get("v.record");
        var fieldApi = cmp.get("v.fieldName");
        var value = obj[fieldApi] || ''; 
        cmp.set("v.newValue",value);
        
    },
    changevalue : function(cmp,event,helper){
        cmp.set("v.oldValue",cmp.get("v.newValue"));
        cmp.set("v.defaultMode","edit");
        
    },
    updateFieldValue : function(cmp, event, helper) {
        var value = cmp.get("v.oldValue") || '';
        helper.saveField(cmp,event,helper,value);
        
    },
    cancelUpdateFieldVal : function(cmp,event,helper){
        cmp.set("v.defaultMode","view");
        
    },
    changeObjValue : function(cmp,event,helper){
        
        if(cmp.get("v.defaultMode") == 'new'){
            var obj = cmp.get("v.record");
            var fieldApi = cmp.get("v.fieldName");
            obj[fieldApi] = cmp.get("v.newValue"); 
            console.log("obj::::",obj);
            cmp.set("v.record",obj);
        }
    }
})
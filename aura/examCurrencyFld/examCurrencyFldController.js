({
    doInit : function(cmp, event, helper) {
        var obj = cmp.get("v.record");
        var fieldApi = cmp.get("v.fieldName");
        var value = obj[fieldApi] || null; 
        cmp.set("v.newValue",value);
        
    },
    changevalue : function(cmp,event,helper){
        cmp.set("v.oldValue",cmp.get("v.newValue"));
        cmp.set("v.defaultMode","edit");
        
    },
    updateFieldValue : function(cmp, event, helper) {
        var value = cmp.get("v.oldValue") || null;
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
({
    doInit : function(cmp, event, helper) {
        var obj = cmp.get("v.record");
        var fieldApi = cmp.get("v.fieldName");
        var value = obj[fieldApi] || ''; 
        console.log("value",value);
        cmp.set("v.newValue",value);
    },
    changevalue : function(cmp,event,helper){
        cmp.set("v.oldValue",cmp.get("v.newValue"));
        
        cmp.set("v.editMode",false);
        cmp.set("v.defaultMode","edit");
    },
    updateFieldValue : function(cmp, event, helper) {
        
        var colorpicker = cmp.find("color").getElement();
        console.log("colorpicker::::",colorpicker);
        var value = colorpicker.value;
        console.log("value",value);
        cmp.set("v.newValue",value);
        cmp.set("v.editMode",true);
        helper.saveField(cmp,event,helper,value);
        
    },
    cancelUpdateFieldVal : function(cmp,event,helper){
        cmp.set("v.defaultMode","view");
        cmp.set("v.editMode",true);
        cmp.set("v.newValue",cmp.get("v.oldValue"));
        
    },
})
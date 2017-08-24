({
    // Generate Value during Comp Initialization
    doInit : function(cmp,event,helper){
        
        var type = cmp.get("v.valType");
        var obj = cmp.get("v.record");
        var fieldApi = cmp.get("v.fieldName");
        var value;
        console.log("type:::",type);
        
        if(type === "STRING" || type === "URL" || type === "PICKLIST" ||
           type === "TEXTAREA" || type === "EMAIL" || type === "Color" ){
            
            value = obj[fieldApi] || ''; 
            cmp.set("v.textValNew",value);
        }
        else if(type === "BOOLEAN"){
            
            value = obj[fieldApi] || false; 
            cmp.set("v.boolValNew",value);
        } 
        else if(type === "DOUBLE" || type === "CURRENCY" ||
                type === "PHONE" || type === "PERCENT" ){
            
            value = obj[fieldApi] || ''; 
            cmp.set("v.numberValNew",value);
        }
        else if(type === "number"){
            
            value = cmp.get("v.numberValNew");
        }
        else if(type === "DATE"){
            
            value = obj[fieldApi] || ''; 
            cmp.set("v.dateValNew",value);
        }
        else if(type === "DATETIME"){
            
            value = obj[fieldApi] || ''; 
            cmp.set("v.dateTimeValNew",value);
        }
        else if(type === "File"){
            value = helper.fileNameConstruct(cmp,event);
            console.log("construct::::",value);
        }
        
        helper.displayValue(cmp,event,type,value);
    },
    
    // update FieldValue
    updateFieldValue : function(cmp, event, helper) {
        cmp.set("v.showSpinner",true);
        var type = cmp.get("v.valType");
        var value;
        
        if(type === "STRING" || type === "URL" || type === "PICKLIST" || type === "TEXTAREA"
          || type === "EMAIL"){
            if(cmp.get("v.search")){
                
                var parentDiv = cmp.find("createInputCmp");
                var body = parentDiv.get("v.body");
                console.log("body:::::",body);
                var staticResourceCmp;
                
                for(var i = 0; i < body.length; i++){
                    staticResourceCmp = body[i].find("staticResource");
                    break;
                }
                value = staticResourceCmp.get("v.searchString");
                console.log("search String in Parent cmp",value);
                
            }
           /*  else 
            }*/
            else{
                value = cmp.get("v.textValNew") || '';
            }
            
        }
        else if(type === "BOOLEAN"){
            
            value = cmp.get("v.boolValNew") || false;
        } 
        else if(type === "DOUBLE" || type === "CURRENCY" ||
                type === "PHONE" || type === "PERCENT"){
            
            value = cmp.get("v.numberValNew") || '';
        }
        else if(type === "DATE"){
            
            value = cmp.get("v.dateValNew") || '';
        }
        else if(type === "DATETIME"){
            
            value = cmp.get("v.dateTimeValNew") || '';
        }
        else if(type === "Color"){
            
            var color_pic = document.getElementById("color_pick");
            value = color_pic.value;
        }
        else if(type === "File"){
            
            var parentDiv = cmp.find("createInputCmp");
            var body = parentDiv.get("v.body");
            console.log("body:::::",body);
            var fileAttachment;
            
            for(var i = 0; i < body.length; i++){
                fileAttachment = body[i].find("fileAttachment");
                break;
            }
            
            fileAttachment.uploadToServer(function(attachment){
                console.log(attachment);
                cmp.set("v.attachment",attachment);
                cmp.set("v.showSpinner",false);
                cmp.set("v.editView",false);
                var value = helper.fileNameConstruct(cmp,event);
                helper.displayValue(cmp,event,"File",value);
            },function(response){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                }
            });
        }
        if(type !== "File"){
            var param = {
                "ObjectName" : cmp.get("v.sObjectAPI"),
                "id" : cmp.get("v.Id"),
                "fieldName" : cmp.get("v.fieldName"),
                "fieldVal" : value
            };
            
            window.AssessmentServiceComponent.updateRecord(param, function(record){
                console.log("record",record);
                var updateFields = cmp.getEvent("updateFields");
                updateFields.setParams({
                    "sObject" : record
                });
                updateFields.fire();
                console.log("success");
                cmp.set("v.showSpinner",false);
                cmp.set("v.editView",false);
                
                helper.displayValue(cmp,event,type,value);
                
            },function(error){
                console.log(":::::",error);
            });
            
           /* var action = cmp.get("c.updateRecord");
            action.setParams({
                "ObjectName" : cmp.get("v.sObjectAPI"),
                "id" : cmp.get("v.Id"),
                "fieldName" : cmp.get("v.fieldName"),
                "fieldVal" : value
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log("state::::::",state);
                if (cmp.isValid() && state === "SUCCESS") {
                    var updateFields = cmp.getEvent("updateFields");
                    updateFields.setParams({
                        "sObject" : response.getReturnValue()
                    });
                    updateFields.fire();
                    console.log("success");
                    cmp.set("v.showSpinner",false);
                    cmp.set("v.editView",false);
                    
                    helper.displayValue(cmp,event,type,value);
                }
            });
            $A.enqueueAction(action);*/
            
        }
        
    },
    // change value
    changevalue : function(cmp,event,helper){
        cmp.set("v.editView",true);
        var uiCmps = [];
        var type = cmp.get("v.valType");
        var value,cmpName,className,options;
        
        if(type === "STRING"){
            
            cmp.set("v.textValOld",cmp.get("v.textValNew"));
            value = cmp.getReference("v.textValNew"); 
            className = "slds-input slds-size--7-of-8";
            if(cmp.get("v.search")){
                cmpName = "c:staticResourceLookupCmp";
                var div2 = cmp.find("createInputCmp");   
                helper.createStaticResourceCmp(cmp,uiCmps,value,cmpName,div2);
            }else{
                cmpName = "ui:inputText";
                helper.createInputCmp(cmp,uiCmps,value,cmpName,className);
            }
            
        }
        else if(type === "TEXTAREA"){
            
            cmp.set("v.textValOld",cmp.get("v.textValNew"));
            value = cmp.getReference("v.textValNew"); 
            cmpName = "ui:inputTextArea";
            className = "slds-textarea slds-size--7-of-8 textAreaClass";
            helper.createInputCmp(cmp,uiCmps,value,cmpName,className);
        }
        else if(type === "URL"){
            
            cmp.set("v.textValOld",cmp.get("v.textValNew"));
            value = cmp.getReference("v.textValNew"); 
            cmpName = "ui:inputURL";
            className = "slds-input slds-size--7-of-8";
            helper.createInputCmp(cmp,uiCmps,value,cmpName,className);
        }
        else if(type === "BOOLEAN"){
            
            cmp.set("v.boolValOld",cmp.get("v.boolValNew"));
            value = cmp.getReference("v.boolValNew"); 
            cmpName = "ui:inputCheckbox";
            className = "slds-checkbox";
            helper.createInputCmp(cmp,uiCmps,value,cmpName,className);
        }
        else if(type === "PICKLIST"){
            
            cmp.set("v.textValOld",cmp.get("v.textValNew"));
            options = cmp.get("v.options");
            helper.createDropdownPicklist(cmp,options);
        }
        else if(type === "EMAIL"){
            
            cmp.set("v.textValOld",cmp.get("v.textValNew"));
            value = cmp.getReference("v.textValNew"); 
            cmpName = "ui:inputEmail";
            className = "slds-input slds-size--7-of-8";
            helper.createInputCmp(cmp,uiCmps,value,cmpName,className);                
        }
        else if(type === "DOUBLE" || type === "PERCENT"){
            
            cmp.set("v.numberValOld",cmp.get("v.numberValNew"));
            value = cmp.getReference("v.numberValNew"); 
            cmpName = "ui:inputNumber";
            className = "slds-input slds-size--7-of-8";
            helper.createInputCmp(cmp,uiCmps,value,cmpName,className);
        }
        else if(type === "PHONE"){
            cmp.set("v.numberValOld",cmp.get("v.numberValNew"));
            value = cmp.getReference("v.numberValNew"); 
            cmpName = "ui:inputPhone";
            className = "slds-input slds-size--7-of-8";
            helper.createInputCmp(cmp,uiCmps,value,cmpName,className);
                        
        }
        else if(type === "CURRENCY"){
            
            cmp.set("v.numberValOld",cmp.get("v.numberValNew"));
            value = cmp.getReference("v.numberValNew"); 
            cmpName = "ui:inputCurrency";
            className = "slds-input slds-size--7-of-8";
            helper.createInputCmp(cmp,uiCmps,value,cmpName,className);
                            
        }
        else if(type === "DATE"){
            
            cmp.set("v.dateValOld",cmp.get("v.dateValNew"));
            value = cmp.getReference("v.dateValNew"); 
            cmpName = "ui:inputDate";
            className = "slds-input slds-size--7-of-8";
            helper.createInputCmp(cmp,uiCmps,value,cmpName,className);
        }
        else if(type === "DATETIME"){
            
            cmp.set("v.dateTimeValOld",cmp.get("v.dateTimeValNew"));
            value = cmp.getReference("v.dateTimeValNew"); 
            cmpName = "ui:inputDateTime";
            className = "slds-input slds-size--7-of-8";
            helper.createInputCmp(cmp,uiCmps,value,cmpName,className);
        }
        else if(type === "Color"){
            
            cmp.set("v.textValOld",cmp.get("v.textValNew"));
            value = cmp.get("v.textValNew"); 
            console.log("value::::::",value);
            cmpName = "aura:html";
            var div2 = cmp.find("createInputCmp");   
            var disabled = false;
            helper.createAuraHtmlTag(cmp,uiCmps,value,cmpName,div2,disabled);
        }
        else if(type === "File"){
            cmpName = "c:fileAttachmentCmp";
            var div2 = cmp.find("createInputCmp");   
            var disabled = false;
            value = helper.fileNameConstruct(cmp,event);
            helper.createFileInputTag(cmp,uiCmps,value,cmpName,div2,disabled);
        }
        
    },
    // cancel update field value 
    cancelUpdateFieldVal : function(cmp,event,helper){
        
        cmp.set("v.editView",false);
        var type = cmp.get("v.valType");
        var value;
        
        if(type === "STRING" || type === "URL" || type === "PICKLIST" ||
           type === "TEXTAREA" || type === "EMAIL" || type === "Color"){
            
            value = cmp.get("v.textValOld");
            cmp.set("v.textValNew",value);
        }
        else if(type === "BOOLEAN"){
            
            value = cmp.get("v.boolValOld");
            cmp.set("v.boolValNew",value);
        } 
        else if(type === "DOUBLE" || type === "CURRENCY" ||
                type === "PHONE" || type === "PERCENT"){
            
            value = cmp.get("v.numberValOld");; 
            cmp.set("v.numberValNew",value);
        }
        else if(type === "DATE"){
            
            value = cmp.get("v.dateValOld"); 
            cmp.set("v.dateValNew",value);
        }
        else if(type === "DATETIME"){
            
            value = cmp.get("v.dateTimeValOld"); 
            cmp.set("v.dateTimeValNew",value);
        }
        else if(type === "File"){
            value = helper.fileNameConstruct(cmp,event);
        }
  
        helper.displayValue(cmp,event,type,value);
    },
    
})
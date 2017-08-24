({  
	createUiCmps : function(cmp,uiCmps,div) {
        $A.createComponents(uiCmps,
            function(components, status, errorMessage){
                
                if (status === "SUCCESS") {
                    console.log("success");
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
    createOutputCmp : function(cmp,uiCmps,value,cmpName){
        console.log(value,cmpName);
        
        if(cmpName === "ui:outputURL"){
            var attrs = {
                "value" : value,
                "label" : value
            };
        }else{
            var attrs = {
                "value" : value
            };
        }
        
        var uiCmp = [
            cmpName,
            attrs
        ];
        
        uiCmps.push(uiCmp);
        var div1 = cmp.find("createOutputCmp");   
        this.createUiCmps(cmp,uiCmps,div1);
    },
    createInputCmp : function(cmp,uiCmps,value,cmpName,className){
        console.log(cmpName);
        
        
        var attrs = {
            "value" : value,
            "class" : className
        };
        var uiCmp = [
            cmpName,
            attrs
        ];
       
        uiCmps.push(uiCmp);
        var div2 = cmp.find("createInputCmp");   
        this.createUiCmps(cmp,uiCmps,div2);
    },
    
    createDropdownPicklist : function(cmp,options){
        var uiCmps=[];
        var opts = [];
        if(options){
            
            console.log("options",options);
            for(var i = 0; i < options.length; i++){
                var attrs = {
                    "class" : "optionClass",
                    "label" : options[i],
                    "value"  : options[i]
                };
                
                opts.push(attrs);                    
            }
        }
        
        var attrs = {
            "class" : "slds-select slds-size--7-of-8",
            "value" : cmp.getReference("v.textValNew"),
            "options" : opts
        };
        var uiCmp = [
            "ui:inputSelect",
            attrs
        ];
        
        uiCmps.push(uiCmp);
        var div2 = cmp.find("createInputCmp");   
        this.createUiCmps(cmp,uiCmps,div2);
    },
    displayValue : function(cmp, event,type,value){
        
        var uiCmps = [];
        
        if(type === "STRING"){
            var cmpName = "ui:outputText";
            this.createOutputCmp(cmp,uiCmps,value,cmpName);
        }
        else if(type === "TEXTAREA"){
            
                var cmpName = "ui:outputTextArea";
                this.createOutputCmp(cmp,uiCmps,value,cmpName);
            
        }
        else if(type === "PICKLIST"){
            var cmpName = "ui:outputText";
            this.createOutputCmp(cmp,uiCmps,value,cmpName);
        }
        else if(type === "URL"){
            var cmpName = "ui:outputURL";
            this.createOutputCmp(cmp,uiCmps,value,cmpName);
        }
        else if(type === "BOOLEAN"){
            var cmpName = "ui:outputCheckbox";
            this.createOutputCmp(cmp,uiCmps,value,cmpName);
        }
        else if(type === "number"){
            var cmpName = "ui:outputNumber";
            this.createOutputCmp(cmp,uiCmps,value,cmpName);
        }
        else if(type === "EMAIL"){
            var cmpName = "ui:outputEmail";
            this.createOutputCmp(cmp,uiCmps,value,cmpName);
        }
        else if(type === "DOUBLE" || type === "PERCENT"){
            var cmpName = "ui:outputNumber";
            this.createOutputCmp(cmp,uiCmps,value,cmpName);
        }
        else if(type === "PHONE"){
            var cmpName = "ui:outputPhone";
            this.createOutputCmp(cmp,uiCmps,value,cmpName);                    
        }
        else if(type === "CURRENCY"){
            var cmpName = "ui:outputCurrency";
            this.createOutputCmp(cmp,uiCmps,value,cmpName);
        }
        else if(type === "DATE"){
            var cmpName = "ui:outputDate";
            this.createOutputCmp(cmp,uiCmps,value,cmpName);
        }
        else if(type === "DATETIME"){
            var cmpName = "ui:outputDateTime";
            this.createOutputCmp(cmp,uiCmps,value,cmpName);
        }
        else if(type === "Color"){
            var cmpName = "aura:html";
            var div1 = cmp.find("createOutputCmp");   
            var disabled = true;
            this.createAuraHtmlTag(cmp,uiCmps,value,cmpName,div1,disabled);
            
        }
        else if(type === "File"){
            var cmpName = "c:fileAttachmentCmp";
            var div1 = cmp.find("createOutputCmp");   
            var disabled = true;
            this.createFileInputTag(cmp,uiCmps,value,cmpName,div1,disabled);
        }
        
    },
    createAuraHtmlTag : function(cmp,uiCmps,value,cmpName,div,disabled){
        
        var HTMLAttributes = {
            "type" : "color",
            "value" : value,
            "disabled" : disabled,
            "id" : "color_pick"
        };
        
        var tag = {
            "tag" : "input",
            HTMLAttributes
        };
            var uiCmp = [
            "aura:html",
            tag
            ];
            
            uiCmps.push(uiCmp);
            this.createUiCmps(cmp,uiCmps,div);
    },
    createFileInputTag : function(cmp,uiCmps,value,cmpName,div,disabled){
        
        var attrs = {
            "aura:id" : "fileAttachment",
            "parentId" : cmp.get("v.record").Id,
            "disabled" : disabled,
            "fileName" : value
        };
        var uiCmp = [
            cmpName,
            attrs
        ];
       
        uiCmps.push(uiCmp);
        this.createUiCmps(cmp,uiCmps,div);
            
    },     
    
    onError : function(response){
        console.log("Error");
    },
    fileNameConstruct : function(cmp,event){
        var value = cmp.get("v.attachment").Name;
        if(value){
            var contentType = cmp.get("v.attachment").ContentType;
            console.log("contentType");
            contentType = contentType.split('/');
            value = value+'.'+contentType[1];
        }else{
            value = "No file";
        }
	return value;
    },
    createStaticResourceCmp : function(cmp,uiCmps,value,cmpName,div){
        var attrs = {
            "aura:id" : "staticResource",
            "searchString" : value
        };
        var uiCmp = [
            cmpName,
            attrs
        ];
        
        uiCmps.push(uiCmp);
        this.createUiCmps(cmp,uiCmps,div);
                
    }
    
})
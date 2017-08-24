({
    doInit: function(cmp, event, helper) {
      var objApi = cmp.get('v.objApi');
      console.log("AssssssessibleObject::::::", objApi);

      helper.doInit(cmp, event, helper);

    },
    changeTemplateAction: function(cmp, event, helper) {
        cmp.set("v.showSpinner", true);
        var templateActions = cmp.find("templateActions");
        templateActions.set("v.body", []);
        var attributes = {
            ObjTemplate: cmp.get("v.ObjTemplate"),
            fields: cmp.get("v.fields"),
            attachment : cmp.get("v.attachment")
        };
        var nextCmp = event.getParam("componentLink");
        $A.createComponent(
            "c:" + nextCmp, attributes,
            function(retCmp, status, message) {
                console.log(message);

                //templateActions = cmp.find("templateActions");
                var body = templateActions.get("v.body");
                body.push(retCmp);
                templateActions.set("v.body", body);
                cmp.set("v.showSpinner", false);

            });
    },

    navigateToObjTable: function(cmp, event, helper) {
        cmp.set("v.hasName", false);
        cmp.set("v.showNavTab", false);
        window.ObjServiceComponent.clearCurrentObjContext();

    },
    ObjLoadEvt: function(cmp, event, helper) {

        var ObjId = event.getParam("ObjId");
        var isNew = event.getParam("isNew");
        console.log("ObjId:::", ObjId);

        if(isNew){
            cmp.set("v.isNew",isNew);
        }
        cmp.set("v.ObjId", ObjId);
        cmp.set("v.hasName", true);
        cmp.set("v.showNavTab", true);
        helper.doInit(cmp, event, helper);

        window.ObjServiceComponent.setCurrentObjContext(ObjId);

    },

    refreshData: function(cmp, event, helper) {
        console.log("reloaded content");
        var sobject = event.getParam("sObject");

        if (sobject.Id == cmp.get("v.ObjId")) {
            var objectKeys = Object.keys(sobject);
            var fieldApi = objectKeys[1];

            if(fieldApi == 'Template_name__c'){
                window.ObjServiceComponent.updateObjList(sobject);
            }

            var ObjTemp = cmp.get("v.ObjTemplate");
            ObjTemp[fieldApi] = sobject[fieldApi];
            cmp.set("v.ObjTemplate", ObjTemp);
        }

    },
    reloadFileContent : function(cmp, event, helper){
        var attachment = event.getParam("attachment");
        cmp.set("v.attachment",attachment);
    },
    saveNewSec : function(cmp,event,helper){
        console.log("section will be saved");
        var SectionTemplate = event.getParam("sectionTemplate");
        console.log("SectionTemplate",SectionTemplate);
        var SectionTemplates = cmp.get("v.SectionTemplates");
        SectionTemplates.push(SectionTemplate);
        cmp.set("v.SectionTemplates",SectionTemplates)
    },
    moveSection : function(cmp,event,helper){

        var sectionTemplates = cmp.get("v.SectionTemplates");
        var index = event.getParam("index");
        var direction = event.getParam("direction");
        console.log("index",index,"sec Length",sectionTemplates.length - 1,"direction",direction);
        if((index === 0 && direction === 'up') || (index === sectionTemplates.length - 1 && direction === 'down')){
            console.log("please check action");
        }else{
            cmp.set("v.showSpinner",true);

            var param = {
                "sectionTemplates" : sectionTemplates,
                "index" : index,
                "direction" : direction
            }
            var status,message;

            window.SectionServiceComponent.updateSectionPostion(param,function(sectionTemplates){
                status = "success";
                message = "Move Section Successfully "+direction;
                helper.showNotificationEvt(cmp,event,helper,status,message);
                cmp.set("v.showSpinner",false);
                console.log("sectionTemplates:::: "+sectionTemplates);
                console.log(":::::::",sectionTemplates);
                var changeElement = sectionTemplates[index];
                console.log("changeElement::",changeElement);
                if(direction == 'up'){
                    sectionTemplates.splice(index, 1);
                    sectionTemplates.splice(index-1, 0, changeElement);
                }
                if(direction == 'down'){
                    sectionTemplates.splice(index, 1);
                    sectionTemplates.splice(index+1, 0, changeElement);
                }
                cmp.set("v.SectionTemplates",sectionTemplates);

            },function(error){
                cmp.set("v.showSpinner",false);
                console.log(":::::",error);
            });
        }
    }
})
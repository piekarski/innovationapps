({
  //component initialization modal show for create Obj Template
  doInit: function(cmp, event, helper) {

  },
  closeModal: function(cmp, event, helper) {
    var cancelCreateNewObj = cmp.getEvent("ObjCancelCreateEvt");
    console.log("cancelCreateNewObj::::::", cancelCreateNewObj);
    cancelCreateNewObj.fire();
    helper.destroyCmp(cmp);
  },
  criteriaChange: function(cmp, event, helper) {
    var AMTemplate = cmp.get("v.issueRequestLifeCycle");
    AMTemplate.ExAM__InvestigationType__c = event.getParam("value");
    AMTemplate.ExAM__Assessment_Template_Type__c = event.getParam("label");

  },
  saveObjTemplate: function(cmp, event, helper) {

    var objApi = cmp.get('v.objApi');
    var objLabel = cmp.get('v.objLabel');
    var AMTemplate = cmp.get("v.issueRequestLifeCycle");
    console.log("ExAM__InvestigationType__c::::::", AMTemplate.ExAM__InvestigationType__c);

    if (AMTemplate.ExAM__Issue_request__c && AMTemplate.ExAM__InvestigationType__c) {
      AMTemplate.sobjectType = "ExAM__IssueRequest_Life_Cycle__c";

      var param = {
        "AMTemplate": AMTemplate,
        "objApi": objApi,
        "objLabel": objLabel
      };
      console.log("param", param);

      window.ObjServiceComponent.createNewAObj(param, $A.getCallback(
        function(Obj) {
          var ObjId = Obj.Id
          console.log("ObjId", ObjId);

          var status = "success";
          var message = cmp.get("v.objLabel") + " application created successfully";
          var time = 5000;
          var showNotificationEvent = $A.get("e.c:NotificationEvt");
          showNotificationEvent.setParams({
            "action": status,
            "message": message,
            "time": time
          });
          showNotificationEvent.fire();

          var cancelCreateNewObj = cmp.getEvent("ObjCancelCreateEvt");
          cancelCreateNewObj.setParams({
            "ObjId": ObjId
          });
          cancelCreateNewObj.fire();
          helper.destroyCmp(cmp);


        }), null);
    } else {
      var status = "warning";
      var message = "Please enter a name and funding level to continue";
      var time = 5000;
      var showNotificationEvent = $A.get("e.c:NotificationEvt");
      showNotificationEvent.setParams({
        "action": status,
        "message": message,
        "time": time
      });
      showNotificationEvent.fire();

    }
  }
})

({
    windowClick: null,

    getObjList: function(cmp, event, helper) {
      cmp.set("v.showSpinner", true);

      var objFields = JSON.stringify(cmp.get("v.objFields"));
      // console.log(":objFieldsJSON::::", objFields);
      var param = {

        "objApi": cmp.get("v.objApi"),
        "objFields": objFields,
        "objFilter": cmp.get("v.objFilter"),
        "objOrder": cmp.get("v.objOrder")

      };
      // console.log(":objFields::::", cmp.get("v.objFields"));

      window.ObjServiceComponent.getObjList(param, function(objList) {
        cmp.set("v.showSpinner", true);

        cmp.set("v.totalObjTemplates", objList);
        // console.log(":objList::::", objList);
        helper.showRecords(cmp, helper, 0, 99, objList);
      }, function(error) {
        console.log(":error::::", error);
      });

    },
    dialogSpawn: function(cmp, event, helper) {
    var dialogType = event.currentTarget.getAttribute("data-dialogType");
    const objLabel = cmp.get("v.objLabel")
    cmp.set("v.dialogObjId", event.currentTarget.getAttribute("data-objId"));
    cmp.set("v.dialogAMId", event.currentTarget.getAttribute("data-AMId"));
    console.log(":dialogType::::", dialogType);
    if (dialogType == "dialogNameEdit") {

      cmp.set("v.dialogSubmitText", "Update Name");
      cmp.set("v.dialogNameEdit", true);
      cmp.set("v.dialogStatusEdit", false);

      cmp.set("v.dialogTitle", "Update " + objLabel + " Name");
    }
    else if (dialogType == "dialogStatusEdit") {
      cmp.set("v.dialogSubmitText", "Submit");
      cmp.set("v.dialogStatusEdit", true);
      cmp.set("v.dialogNameEdit", false);
      cmp.set("v.dialogTitle", "Submit " + objLabel + ' Application');
    }
    this.showModal(cmp, event);
  },
  dialogSubmit: function(cmp, event, helper) {
    var fieldValue, AMFieldName, objFieldName;
    if (cmp.get("v.dialogNameEdit") == true) {
       fieldValue = cmp.find("nameInput").get("v.value");
       objFieldName = "Name";
       AMFieldName = "ExAM__Issue_request__c";
    }
    else if (cmp.get("v.dialogStatusEdit")== true) {

      fieldValue = "Submitted"
      objFieldName = "Additional_Status__c";
      AMFieldName = "Additional_Status__c";
    }
      var param = {
        "ObjectName": cmp.get("v.objApi"),
        "id": cmp.get("v.dialogObjId"),
        "fieldName": objFieldName,
        "fieldVal": fieldValue
      };
      var paramAM = {
        "ObjectName": "ExAM__IssueRequest_Life_Cycle__c",
        "id": cmp.get("v.dialogAMId"),
        "fieldName": AMFieldName,
        "fieldVal": fieldValue
      };
      console.log(":paramAM::::", paramAM);

      helper.saveAssessables(cmp, event, helper, param, paramAM);

    if (cmp.get("v.dialogSubmitApp")) {

    }
  },
  saveAssessables: function(cmp, event, helper, param, paramAM) {

    var status, message;
    var fieldLabel = param.fieldName;
    helper.modalAction(cmp, event);

    window.ObjServiceComponent.updateRecord(param, $A.getCallback(function(record) {
      if (cmp.isValid()) {

        window.ObjServiceComponent.updateRecord(paramAM, $A.getCallback(function(record) {


          helper.getObjList(cmp, event, helper);
          status = "success";
          message = cmp.get("v.objLabel") + " Submitted";

          helper.showNotificationEvt(cmp, event, status, message);
          //helper.updateFieldsEvt(cmp, event, helper, record);

        }), $A.getCallback(function(error) {

          if (cmp.isValid()) {
            status = "error";
            message = fieldLabel + " Not Updated";
            helper.showNotificationEvt(cmp, event, status, message);
          }

        }))

      }

    }), $A.getCallback(function(error) {

      if (cmp.isValid()) {
        status = "error";
        message = fieldLabel + "Not Updated";
        helper.showNotificationEvt(cmp, event, status, message);
      }

    }));


  },
  saveField: function(cmp, event, helper, param) {

    var status, message;
    var fieldLabel = param.fieldName;
    helper.modalAction(cmp, event);

    window.ObjServiceComponent.updateRecord(param, $A.getCallback(function(record) {
      if (cmp.isValid()) {

        helper.getObjList(cmp, event, helper);
        status = "success";
        message = fieldLabel + " Updated";
        helper.showNotificationEvt(cmp, event, status, message);
        //helper.updateFieldsEvt(cmp, event, helper, record);
      }

    }), $A.getCallback(function(error) {

      if (cmp.isValid()) {
        status = "error";
        message = fieldLabel + " Updated";
        helper.showNotificationEvt(cmp, event, helper, status, message);
      }

    }));


  },
  showModal: function(cmp) {
    var modal = cmp.find("modal");
    $A.util.addClass(modal, "slds-fade-in-open");

    var backdrop = cmp.find("backdrop");
    $A.util.addClass(backdrop, "slds-backdrop--open");
  },
  itemClicked: function(cmp, event, helper) {
    var fieldDestination = event.getParam("fieldDestination");
    var prefix = 'http';


    if (fieldDestination.startsWith(prefix)) {
      helper.callUrl(cmp, event);
    } else {
      helper.callComponent(cmp, event);
    }
  },
  callUrl: function(cmp, event) {
    var url = event.getParam("fieldDestination");
    window.open(url);
  },
  callComponent: function(cmp, event, helper) {
    console.log(":fieldDestination::::", event.getParam("fieldDestination"));
  },

  // Show Records

  showRecords: function(cmp, helper, startIndex, endIndex, s) {
    var min = 1;
    var noOfRecordPerPage = cmp.get("v.recordPerPage");
    var noOfs = s.length;
    var max = Math.ceil(noOfs / noOfRecordPerPage);
    cmp.set("v.max", max);

    var _Temp = [];
    var lastIndex = s.length - 1;

    if (lastIndex < endIndex) {
      endIndex = lastIndex;
    }

    for (var i = startIndex; i <= endIndex; i++) {
      //
      // console.log("end index:::",endIndex);
      if (s[i]) {
        // console.log("s:::",s[i].Template_name__c);
        _Temp.push(s[i]);
      }

    }
    cmp.set("v.ObjTemplates", JSON.parse(JSON.stringify(_Temp)));
    cmp.set("v.showSpinner", false);

  },


  // clone Record
  cloneRecord: function(cmp, event, helper, recordId) {
    var template_Name = cmp.get("v.template_Name");

    var param = {
      "recordId": recordId,
      "temp_name": template_Name
    };
    var status, message;
    window.ServiceComponent.cloneWithRelatedSections(param, function(Templates) {
      cmp.set("v.showSpinner", false);
      helper.modalAction(cmp, event);
      console.log("length::::", cmp.set("v.totalTemplates").length);
      console.log("length::::", Templates.length);
      cmp.set("v.totalTemplates", Templates);
      status = "success";
      message = "Object cloned Success !";
      helper.showNotificationEvt(cmp, event, helper, status, message);
      helper.refreshTable(cmp, event);

    }, function(error) {
      cmp.set("v.showSpinner", false);
      helper.modalAction(cmp, event);
      status = "error";
      message = "Sorry, template clone failed";
      helper.showNotificationEvt(cmp, event, helper, status, message);
    });
  },

  refreshTable: function(cmp, event) {

    var s = cmp.get("v.totalTemplates");
    var perPage = cmp.get("v.recordPerPage");
    var currentPage = cmp.get("v.currentPage");

    var startIndex = (currentPage - 1) * perPage;
    var endIndex = (currentPage * perPage) - 1;

    this.showRecords(cmp, startIndex, endIndex, s);

  },
  archive: function(cmp, event, helper, selected) {
    console.log("index::", selected);

    var status, message;
    window.ServiceComponent.archive(selected, $A.getCallback(function(Templates) {

      if (cmp.isValid()) {
        cmp.set("v.totalTemplates", JSON.parse(JSON.stringify(Templates)));
        status = "success";
        message = "Application archived";
        helper.showNotificationEvt(cmp, event, helper, status, message);
        helper.refreshTable(cmp, event);
      }

    }), $A.getCallback(function(error) {

      if (cmp.isValid()) {
        status = "error";
        message = "Application not archived";
        helper.showNotificationEvt(cmp, event, helper, status, message);
      }

    }));
  },
  modalAction: function(cmp, event) {

    var modal = cmp.find("modal");
    var backdrop = cmp.find("backdrop");
    $A.util.toggleClass(modal, "slds-fade-in-open");
    $A.util.toggleClass(backdrop, "slds-backdrop--open");
  },

  toggleDropdown: function(cmp, event) {
    var indexCmp = cmp.get("v.index");
    var index = event.currentTarget.getAttribute("data-index");

    if (indexCmp && indexCmp != parseInt(index)) {
      console.log("true");
      this.closeDropdown(cmp, event);
    }

    var dropdown = cmp.find('dropdown');

    if (!Array.isArray(dropdown)) {
      dropdown = [dropdown];
    }

    console.log("index:::click:::", index);
    cmp.set("v.index", index);
    $A.util.toggleClass(dropdown[index], 'slds-is-open');
    event.stopPropagation();
  },

  closeDropdown: function(cmp, event) {
    var dropdown = cmp.find('dropdown');

    if (!Array.isArray(dropdown)) {
      dropdown = [dropdown];
    }

    var index = cmp.get("v.index");
    for (var i = 0; i < dropdown.length; i++) {
      if (i == parseInt(index)) {
        $A.util.removeClass(dropdown[index], 'slds-is-open');
      }
    }
  },
  showNotificationEvt: function(cmp, event, helper, status, message) {
    var showNotificationEvent = $A.get("e.c:NotificationEvt");
    showNotificationEvent.setParams({
      "action": status,
      "message": message
    });
    showNotificationEvent.fire();
  },
  toggleBtn: function(cmp, event) {
    var hideBtn = cmp.find("addBtn");
    $A.util.toggleClass(hideBtn, 'slds-hide');
  },
  sort: function(cmp, sorting, column) {

    var Templates = cmp.get("v.totalObjTemplates");
    console.log('Templates:::', Templates);

    Templates.sort(function(a, b) {

      if (sorting.order == "asc") {

        if (a[column] > b[column]) {

          return 1;
        } else if (a[column] < b[column]) {
          return -1;
        }

        return 0;
      } else {

        if (a[column] < b[column]) {
          return 1;
        } else if (a[column] > b[column]) {
          return -1;
        }

        return 0;
      }

    });

    return Templates;
  },
  updateFieldsEvt: function(cmp, event, helper, record) {
    var updateFields = cmp.getEvent("updateFields");
    updateFields.setParams({
      "sObject": record
    });
    updateFields.fire();
  },
  showNotificationEvt: function(cmp, event, status, message, time) {
    var showNotificationEvent = $A.get("e.c:NotificationEvt");
    showNotificationEvent.setParams({
      "action": status,
      "message": message,
      "time": time
    });
    showNotificationEvent.fire();
  }
})

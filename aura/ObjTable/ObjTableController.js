({
  // fetch Login user Id

  doInit: function(cmp, event, helper) {
    console.log("objApi", cmp.get("v.objApi"));
    // cmp.set("v.objFields", 'Id, Name, CreatedDate, LastModifiedDate, Public_Assessment_URL__c, Assessment_Template_Type__c');
    cmp.set("v.objOrder", 'CreatedDate DESC');
    helper.getObjList(cmp, event, helper);
    

  },
  itemClicked: function(cmp, event, helper) {
    helper.itemClicked(cmp, event, helper);

  },
  cbTest: function(cmp, event, helper) {
    helper.cbTest(cmp, event, helper);

  },
  showObj: function(cmp, event, helper) {
    var ObjId = event.srcElement.id;
    console.log("ObjId--", ObjId);

    var ObjLoadEvt = cmp.getEvent("ObjLoadEvt");

    ObjLoadEvt.setParams({
      "ObjId": ObjId
    });
    ObjLoadEvt.fire();
  },
  // show Record Based on ItemPerPage

  showRecord: function(cmp, event, helper) {
    var Objs = cmp.get("v.totalObjTemplates");
    var perPage = cmp.get("v.recordPerPage");
    console.log("perPage::", perPage);
    cmp.set("v.currentPage", 1);
    var startIndex = 0;
    var endIndex = perPage - 1;
    helper.showRecords(cmp, startIndex, endIndex, Objs);
  },

  gotoPage: function(cmp, event, helper) {
    var startPage = event.getParam("startPage");
    var recPerPage = cmp.get("v.recordPerPage");
    var startIndex = ((startPage - 1) * recPerPage);
    var endIndex = ((startPage) * recPerPage) - 1;
    var Objs = cmp.get("v.totalObjTemplates");
    helper.showRecords(cmp, startIndex, endIndex, Objs);
  },

  closeNotification: function(cmp, event, helper) {
    cmp.set("v.showNotification", false);
  },

  gotoURL: function(component, event, helper) {
    window.location.href = 'https://examdev-dev-ed.lightning.force.com/c/ExamManager.app';
  },

  showAction: function(cmp, event, helper) {
    helper.toggleDropdown(cmp, event);
  },

  cloneSobjectRecord: function(cmp, event, helper) {
    var index = event.currentTarget.getAttribute("data-index");
    console.log("index::", index);
    cmp.set("v.position", index);
    helper.modalAction(cmp, event);
  },

  closeModal: function(cmp, event, helper) {
    helper.modalAction(cmp, event);
  },

  saveCloneObject: function(cmp, event, helper) {
    var index = cmp.get("v.position");
    var ObjTemplates = cmp.get("v.ObjTemplates");
    console.log("ObjTemplates:::", ObjTemplates);
    var recordId = ObjTemplates[index].Id;
    console.log("recordId::", recordId);
    cmp.set("v.showSpinner", true);
    helper.cloneObjRecord(cmp, event, helper, recordId);
  },

  changeArchive: function(cmp, event, helper) {
    var index = event.currentTarget.getAttribute("data-index");

    var ObjTemplates = cmp.get("v.ObjTemplates");
    var selectedObj = ObjTemplates[index];
    selectedObj.isArchive__c = true;

    helper.archiveObj(cmp, event, helper, selectedObj);
  },
  updateObjList: function(cmp, event, helper) {
    var param = event.getParam('arguments');

    if (param) {
      var Objs = param.totalObj;
      cmp.set("v.totalObjTemplates", Objs);
      var perPage = cmp.get("v.recordPerPage");
      cmp.set("v.currentPage", 1);
      var startIndex = 0;
      var endIndex = perPage - 1;
      helper.showRecords(cmp, startIndex, endIndex, Objs);
    }

  },
  updateName: function(cmp, event, helper) {
    helper.updateName(cmp, event);
  },
  dialogSubmit: function(cmp, event, helper) {
    helper.dialogSubmit(cmp, event, helper);
  },
  dialogSpawn: function(cmp, event, helper) {
    helper.dialogSpawn(cmp, event, helper);
  },
  submitApp: function(cmp, event, helper) {
    helper.submitApp(cmp, event);
  },
  createNewObj: function(cmp, event, helper) {
    helper.toggleBtn(cmp, event);
    var newObj = cmp.find('addNewObj');
    var objApi = cmp.get('v.objApi');
    var objLabel = cmp.get('v.objLabel');
    console.log('objApi:::', objApi);
    $A.createComponent(
      'c:ObjCtrlAdd', {
        'objApi': objApi,
        'objLabel': objLabel
      },
      function(ObjCapture, status, errorMessage) {

        if (status === "SUCCESS") {
          var body = newObj.get("v.body");
          body.push(ObjCapture);
          newObj.set("v.body", body);
        } else if (status === "ERROR") {
          console.log("error:::", errorMessage);
        }

      });
  },
  objCreated: function(cmp, event, helper) {
    helper.getObjList(cmp, event, helper);
    helper.toggleBtn(cmp, event);

  },

  cancelAction: function(cmp, event, helper) {
    var ObjId = event.getParam("ObjId");

    console.log("ObjId:::", ObjId);
    if (ObjId) {
      event.stopPropagation();
      console.log("has Id");
      var ObjLoadEvt = cmp.getEvent("ObjLoadEvt");

      ObjLoadEvt.setParams({
        "ObjId": ObjId,
        "isNew": true
      });
      ObjLoadEvt.fire();
    }
    helper.toggleBtn(cmp, event);
  },
  reloadObj: function(cmp, event, helper) {
    window.ObjServiceComponent.getObjsByCurrentUser($A.getCallback(function(ObjTemplate) {
      helper.toggleBtn(cmp, event);
      cmp.set("v.totalObjTemplates", ObjTemplate);
      helper.refreshObjTable(cmp, event);
    }), $A.getCallback(function() {

    }));
  },
  sortByColumn: function(cmp, event, helper) {
    var column = event.currentTarget.getAttribute("data-name");
    var sorting = cmp.get("v.sorting");

    if (sorting.column != column) {
      sorting.column = column;
      sorting.order = 'desc';
    }

    if (!sorting.order || sorting.order == 'desc') {
      sorting.order = 'asc';
    } else {
      sorting.order = 'desc';
    }

    var ObjTemplates = helper.sort(cmp, sorting, column);

    if (ObjTemplates) {
      var currentPage = cmp.get("v.currentPage");
      cmp.set("v.totalObjTemplates", ObjTemplates);
      cmp.set("v.sorting", sorting);

      if (currentPage != 1) {
        currentPage = 1;
        cmp.set("v.currentPage", currentPage);
      }

      var perPage = cmp.get("v.recordPerPage");
      var startIndex = (currentPage - 1) * perPage;
      var endIndex = (currentPage * perPage) - 1;
      helper.showRecords(cmp, startIndex, endIndex, ObjTemplates);
    }

  }

})

({
  getObjList: function(param, onSuccess, onError, data, cmp) {

    var action = cmp.get("c.getObjList");
    action.setParams(param);
    action.setCallback(this, function(response) {
      var state = response.getState();

      if (cmp.isValid() && state === "SUCCESS") {
        // console.log("getObjList:::::::", response.getReturnValue());

        data.ObjsList = response.getReturnValue();
        onSuccess(response.getReturnValue());
      } else {

        if (!onError) {

        } else {
          onError(response.getError());
        }

      }
      
    });

    $A.enqueueAction(action);

  },
  createNewAObj: function(param, onSuccess, onError, data, cmp, event, helper) {
    cmp.set("v.showSpinner", true);

    var action = cmp.get("c.createNewAObj");
    action.setParams(param);
    action.setCallback(this, function(response) {
      var state = response.getState();

      if (cmp.isValid() && state === "SUCCESS") {
        console.log("createNewObj:::::::", response.getReturnValue());

        data._currentObj = response.getReturnValue();
        onSuccess(response.getReturnValue());
      } else {

        if (!onError) {

        } else {
          onError(response.getError());
        }

      }
      cmp.set("v.showSpinner", false);
    });

    $A.enqueueAction(action);

  },
  cloneObjWithRelatedSections: function(param, onSuccess, onError, data, cmp) {
    cmp.set("v.showSpinner", true);
    var action = cmp.get("c.cloneObjTemp");
    action.setParams(param);
    action.setCallback(this, function(response) {
      var state = response.getState();

      if (cmp.isValid() && state === "SUCCESS") {
        var ObjTemplates = data.ObjsList;
        ObjTemplates.splice(0, 0, response.getReturnValue());
        //ObjTemplates.push(response.getReturnValue());
        data.ObjsList = ObjTemplates;
        onSuccess(data.ObjsList);
      } else {

        if (!onError) {

        } else {
          onError(response.getError());
        }

      }
      cmp.set("v.showSpinner", false);
    });

    $A.enqueueAction(action);

  },
  archiveObj: function(selectedAm, onSuccess, onError, data, cmp) {
    cmp.set("v.showSpinner", true);
    console.log("selectedAT:::::::", selectedAm);

    var action = cmp.get("c.archiveObj");
    action.setParams({
      "am": selectedAm
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      console.log("selecteresponse:::::::", response.getReturnValue());

      if (cmp.isValid() && state === "SUCCESS") {
        var ObjTemplates = data.ObjsList;
        console.log("ObjTemplates:::::::", ObjTemplates.length);
        var index; // = ObjTemplates.indexOf(selectedObj);
        for (var i = 0; i < ObjTemplates.length; i++) {
          if (selectedAm.Id == ObjTemplates[i].Id) {
            index = i;
            break;
          }
        }
        ObjTemplates.splice(index, 1);
        console.log("ObjTemplates:::::::", ObjTemplates);
        onSuccess(ObjTemplates);
      } else {

        if (!onError) {

        } else {
          onError(response.getError());
        }

      }
      cmp.set("v.showSpinner", false);
    });

    $A.enqueueAction(action);
  },

  getRecordById: function(param, onSuccess, onError, data, cmp) {
    cmp.set("v.showSpinner", true);

    var action = cmp.get("c.getRecordById");
    action.setParams(param);
    action.setCallback(this, function(response) {
      var state = response.getState();

      if (cmp.isValid() && state === "SUCCESS") {

        data._Objs[param.sObjectId] = JSON.parse(response.getReturnValue());
        console.log("getRecordByIdresponse:::::::", response);

        onSuccess(JSON.parse(response.getReturnValue()));
      } else {

        if (!onError) {

        } else {
          onError(response.getError());
        }

      }
      cmp.set("v.showSpinner", false);
    });
    $A.enqueueAction(action);

  },
  getRecord: function(param, onSuccess, onError, data, cmp) {
    cmp.set("v.showSpinner", true);

    var action = cmp.get("c.getRecord");
    action.setParams(param);
    action.setCallback(this, function(response) {
      var state = response.getState();

      if (cmp.isValid() && state === "SUCCESS") {
        data._Objs[param.sObjectId] = JSON.parse(response.getReturnValue());
        onSuccess(JSON.parse(response.getReturnValue()));
      } else {

        if (!onError) {

        } else {
          onError(response.getError());
        }

      }
      cmp.set("v.showSpinner", false);
    });
    $A.enqueueAction(action);

  },
  updateRecord: function(param, onSuccess, onError, data, cmp) {
    cmp.set("v.showSpinner", true);

    var ObjId = param.id;
    var action = cmp.get("c.updateRecord");
    action.setParams(param);
    action.setCallback(this, function(response) {
      var state = response.getState();

      if (cmp.isValid() && state === "SUCCESS") {

            onSuccess(response.getReturnValue());

      } else {
        if (!onError) {
          console.log("response.getError():::::::", response.getError());

        } else {
          console.log("response.getError():::::::", response.getError());

          onError(response.getError());
        }

      }
      cmp.set("v.showSpinner", false);
    });
    $A.enqueueAction(action);

  },
  updateObjList: function(sobject, data, cmp) {
    var ObjId = sobject.Id;
    var ObjTempList = data.ObjsList;
    for (var i = 0; i < ObjTempList.length; i++) {

      if (ObjTempList[i].Id == ObjId) {
        var objectKeys = Object.keys(sobject);
        var fieldApi = objectKeys[1];
        var ObjRecord = ObjTempList[i];
        ObjRecord[fieldApi] = sobject[fieldApi];
        ObjTempList[i] = ObjRecord;
        data.ObjsList = ObjTempList;
        break;
      }

    }
  },
  FetchAllObj: function(onSuccess, onError, data, cmp) {
    var action = cmp.get("c.fetchAllObjs");
    action.setCallback(this, function(response) {
      var state = response.getState();

      if (cmp.isValid() && state === "SUCCESS") {
        data.ObjsList = response.getReturnValue();
        onSuccess(response.getReturnValue());
      } else {
        if (!onError) {

        } else {
          // onError(response.getError());
        }
      }

    });

    $A.enqueueAction(action);
  },

  fireObjEvent: function(cmp, event) {
    var ObjEvent = $A.get("e.c:fireObjChangedEvt");
    ObjEvent.fire();
  },
  setCurrentObjContext: function(ObjId, data) {
    var ObjList = data.ObjsList;
    var currentObj;
    for (var i = 0; i < ObjList.length; i++) {
      if (ObjList[i].Id == ObjId) {
        currentObj = ObjList[i];
        break;
      }
    }
    data._currentObj = currentObj;
  },
  clearCurrentObjContext: function(data) {
    data._currentObj = {};
  }
})

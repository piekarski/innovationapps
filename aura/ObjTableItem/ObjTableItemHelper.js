({
  createCmpBody: function(cmp) {
    const sobject = cmp.get('v.sobject');
    const fieldScript = cmp.get('v.field.fieldScript');
		const fieldApi = cmp.get('v.field.fieldApi');
		const field = cmp.get('v.field');
    const fieldDestinationType = cmp.get('v.field.fieldDestinationType');
    const id = sobject.Id;
    const fieldDestination = (sobject[fieldDestinationType]) ? sobject[fieldDestinationType] : fieldDestinationType;
		var type = cmp.get('v.field.fieldOutputType');
		type = (!$A.util.isEmpty(type)) ? type : type = 'ui:outputText';
    // console.log('sobject', sobject);
    // console.log(sobject.Id);
		const uiParam = this.getUIParam(cmp, id, field, sobject);
    $A.createComponent(
      type,
      uiParam,
      function(newComponent) {
        cmp.set("v.body", newComponent);
        cmp.set("v.Id", id);
        cmp.set("v.fieldDestination", fieldDestination);

      }
    )
  },
  tableItemDblClicked: function(cmp, event) {
		console.log("ObjTableItemClick");
	},
  tableItemClicked: function(cmp, event) {
    const id = cmp.get("v.Id");
    const fieldDestination = cmp.get("v.fieldDestination");
    const field = cmp.get("v.field");
    var cmpEvent = cmp.getEvent("ObjTableItemClick");
    console.log();
    //var ObjId = event.currentTarget.getAttribute("a");
    cmpEvent.setParams({
      "objId": id,
      "fieldDestination": fieldDestination,
      "field" : field
    });
    cmpEvent.fire();
  },
  getUIParam: function(cmp, Id, field, sobject) {
		var type = cmp.get('v.field.fieldOutputType');
		type = (!$A.util.isEmpty(type)) ? type : type = 'ui:outputText';
    sobject[field.fieldApi];
    const itemVal = sobject[field.fieldApi];
    var uiParam;
    const uiParams = {
      'ui:outputURL': function() {
        uiParam = {
          "value": 'javascript:void()',
          "label": itemVal,
          "click": cmp.getReference("c.tableItemClicked")
        };
      },
      'ui:outputDateTime': function() {
        uiParam = {
          "value": itemVal,
          "format": "MM/dd/yyyy h:mm a"
        };
      },
      'ui:outputText': function() {
        uiParam = {
          "value": itemVal
        };
      }
      ,
      // 'c:ExamTextFld': function() {
      //   uiParam = {
			// 		"record": sobject,
			// 		"editMode": true,
			// 		"Id": sobject[field.fieldApi],
			// 		"sObjectName": 'Innovation_Grant__c',
			// 		"fieldName": field.fieldApi,
			// 		"fieldLabel": field.fieldApi
      //
      //   };
      // }
    };

    uiParams[type]();
    return uiParam;
  }
})

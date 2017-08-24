({
  getObjList: function(cmp, event) {

    var objFields = JSON.stringify(cmp.get("v.displayField"));

    var param = {
      "objApi": cmp.get("v.objApi"),
      "objFields": objFields,
      "objOrder": cmp.get("v.objOrder"),
      "objFilter": cmp.get("v.objFilter")

    };

    window.ObjServiceComponent.getObjList(param, function(objList) {
      var displayField = cmp.get("v.displayField")
      if (objList) {
        var attributes = [];
        for (var i = 0; i < objList.length; i++) {
          var listItem = {
            'optionValue': objList[i].Id,
            'optionLabel': objList[i][displayField[0].fieldLabel]
          }

          attributes.push(listItem);
        }

      }
      cmp.set("v.attributes", attributes)

    }, function(error) {
      console.log(":::::", error);
    });

  }
})

({
  doInit: function(cmp, event, helper) {
    console.log("ctrlLinkMenuObj---", cmp.get("v.objApi"));

    // console.log("totalTemplates",cmp.get("v.totalTemplates"));
    helper.getObjList(cmp, event, helper);

  }
})
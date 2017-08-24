({
  //Calculates the style of Tabs and sets the ACTIVE tab as highlighted in red color.
  calcStyle: function(cmp) {
    var active = cmp.get("v.active");
    var styles;
    if (active) {
      styles += " slds-active bgColor";
    }
    cmp.set("v.stateClass", styles);
  },

  //Fires the Component level event to set the Tab as Active.
  fireEventHelper: function(cmp, indexNum, componentLink) {
    var cmpEvent = cmp.getEvent("SettingSelectedTab");

    cmpEvent.setParams({
      "activeTab": indexNum,
      "componentLink": componentLink
    });
    cmpEvent.fire();
  }
})
({
  windowClick: null,

  toggleDropdown: function(cmp, event) {
      var closeDrop = $A.get("e.c:closeDropDownEvt");
      closeDrop.setParams({
          "index" : cmp.get("v.itemIndex")
      });
      closeDrop.fire();

      var dropdown = cmp.find('dropdown');
      $A.util.toggleClass(dropdown, 'slds-is-open');
      event.stopPropagation();
  },
  closeDropdown: function(cmp, event) {
    var dropdown = cmp.find('dropdown');
    $A.util.removeClass(dropdown, 'slds-is-open');
  },
  fireEventHelper: function(cmp, event) {
    var value = event.currentTarget.getAttribute("data-optionValue");
    var label = event.currentTarget.getAttribute("data-optionLabel");
    var index = cmp.get("v.itemIndex");
    var cmpEvent = cmp.getEvent("ctrlLinkMenuEvt");
    cmpEvent.setParams({
      "value": value,
      "label": label
    });
    cmpEvent.fire();
  }
})
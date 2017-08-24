({
  doInit: function(cmp, event, helper) {

  },
    // toggle Action Menu
  showAction: function(cmp, event, helper) {
    helper.toggleDropdown(cmp, event);
  },
    // select Option
  selectItem: function(cmp, event, helper) {


    helper.fireEventHelper(cmp, event);

    if (cmp.get("v.linkChange")) {
      cmp.set("v.menuLinkText", event.currentTarget.getAttribute(
        "data-optionLabel"));
    }

  },
    // closeDropdown if already other dropDown is open
    closeDropDown : function(cmp,event,helper){
        var index = event.getParam("index");
        var dropdown = cmp.find('dropdown');

        if(index != cmp.get("v.itemIndex") && $A.util.hasClass(dropdown, 'slds-is-open')){
            helper.closeDropdown(cmp,event);
        }
        event.stopPropagation();
    }
})
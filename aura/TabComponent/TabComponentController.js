({
    doInit: function(cmp, event, helper) {
        var current = cmp.get("v.active");
        console.log("activated::::::",current);
        //setting the default tab as ACTIVe tab.
        //  cmp.set("v.link", currentlink);
        if (current) {
            cmp.set("v.stateClass", "slds-active bgColor");
        } else {
            cmp.set("v.stateClass", "");
        }
    },
    //Function used on onClick of tab links.
    fireEvent: function(cmp, event, helper) {
        helper.fireEventHelper(cmp, cmp.get("v.index"), cmp.get("v.componentLink"));
    },

    //Function used for updating the style of selected tab as ACTIVE.
    doUpdate: function(cmp, event, helper) {
      helper.calcStyle(cmp);
    }
})
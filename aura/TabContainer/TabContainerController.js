({
  doInit: function(cmp, event, helper) {

  },

  handleSettingSelectedTab: function(cmp, event, helper) {
      var activeTab = event.getParam("activeTab");
      helper.handleSettingSelectedTab(cmp,activeTab);
  },
    navigateDefaultActiveState : function(cmp,event,helper){
        var params = event.getParam('arguments');
        if (params) {
            var activeTab = params.activeTab;
            helper.handleSettingSelectedTab(cmp,activeTab);
        }
    }
})
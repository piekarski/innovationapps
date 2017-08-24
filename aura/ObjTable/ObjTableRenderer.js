({
    afterRender: function (cmp,helper) {
        this.superAfterRender();
        console.log("after render called");
        helper.windowClick = $A.getCallback(function(event){
            if(cmp.isValid()){
                // console.log("after render called hh");
                helper.closeDropdown(cmp,event);
            }
        });
        document.addEventListener('click',helper.windowClick);

    },
    unrender: function (cmp,helper) {

        this.superUnrender();
        document.removeEventListener('click',helper.windowClick);
    }
})

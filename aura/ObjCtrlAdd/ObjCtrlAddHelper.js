({
    // Save newly create AssessmentTemplate
    destroyCmp : function(cmp) {

        window.setTimeout($A.getCallback(function(){
            if(cmp.isValid()){
                cmp.destroy();
            }
        }),0);

    }
})
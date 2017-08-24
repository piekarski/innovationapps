({
    doInit : function(cmp, event, helper) {
        window.ObjServiceComponent = (function() {

            var data = {
                "ObjsList" : [],
                "_Objs" : {},
                "_currentObj" : {}
            }

            return {
                FetchAllObj : function(onSuccess,onError){

                    if(data.ObjsList.length){
                        onSuccess(data.ObjsList);
                    }else{
                        helper.FetchAllObj(onSuccess,onError,data,cmp);
                    }
                },
                getObjList : function(param, onSuccess,onError){

                    // if(data.ObjsList.length){
                    //     onSuccess(data.ObjsList);
                    // }else{
                        helper.getObjList(param, onSuccess,onError,data,cmp);
                    // }

                },
                cloneObjWithRelatedSections : function(param,onSuccess,onError){
                    helper.cloneObjWithRelatedSections(param,onSuccess,onError,data,cmp);
                },
                archiveObj : function(selectedObj,onSuccess,onError){
                    helper.archiveObj(selectedObj,onSuccess,onError,data,cmp);
                },
                getRecordById : function(params,onSuccess,onError){

                    if(data._Objs[params.sObjectId]){
                        onSuccess(data._Objs[params.sObjectId]);
                    }else{
                        helper.getRecordById(params,onSuccess,onError,data,cmp);
                    }

                },
                getRecord : function(params,onSuccess,onError){

                    if(data._Objs[params.sObjectId]){
                        onSuccess(data._Objs[params.sObjectId]);
                    }else{
                        helper.getRecord(params,onSuccess,onError,data,cmp);
                    }

                },
                updateRecord : function(param,onSuccess,onError){
                    helper.updateRecord(param,onSuccess,onError,data,cmp);
                },
                updateObjList : function(sobject){
                    helper.updateObjList(sobject,data,cmp);
                },
                uploadFileToSerever : function(param,onSuccess,onError){
                    window.AttachmentServiceComponent.uploadFileToSerever(param,onSuccess,onError,data);
                },
                createNewAObj : function(param,onSuccess,onError){

                    helper.createNewAObj(param,onSuccess,onError,data,cmp,event,helper);
                },
                getCurrentObjContext : function(){
                    return data._currentObj;
                },
                setCurrentObjContext : function(ObjId){
                    helper.setCurrentObjContext(ObjId,data);
                },
                clearCurrentObjContext : function(){
                    helper.clearCurrentObjContext(data);
                },
            };
        }());
    }
})

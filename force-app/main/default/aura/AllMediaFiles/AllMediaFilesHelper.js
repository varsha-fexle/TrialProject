({
    //call on component load
    doInit: function(component, event, helper, selectedMenuItem) {
        
        //set spinner time-out
        setTimeout(function() {
            component.set("v.spinnerVisiblity", "false");
        }, 2000);
        
        var action = component.get("c.getAllMediaFiles");
        
        action.setParams({"pageObjName"			: component.get('v.sObjectName'),
                          "selectedObjName"		: component.get('v.selectedSobject'),
                          "recordId"			: component.get("v.recordId"),
                          "mediaFileFilter"		: selectedMenuItem});
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue().isSuccess) {
                    
                    component.set('v.mediaFilesLength', response.getReturnValue().body.length);
                    component.set('v.mediaFiles', response.getReturnValue().body);
                    
                    
                }
                else {
                    helper.showToast(component, event, helper, response.getReturnValue().status, response.getReturnValue().message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    //handle play event on audio tag
    handlePlay : function(component, event, helper) {
        
        //get currently played audio/video id and previously played audio/video id
        var index = event.target.id;
        var prePlayId = component.get('v.playId');
        
        if(prePlayId != index && prePlayId != '' && prePlayId != 'undefined')
            helper.handlePause(prePlayId);
        
        component.set('v.playId',index);
    },
    
    //handle pause event 
    handlePause: function(prePlayId) {
        
        var audio_video = document.getElementById(prePlayId);
        audio_video.pause();
    },
    
    showToast: function(component, event, helper,type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: type+"!",
            type: type,
            message: message
        });
        toastEvent.fire();
    },
})
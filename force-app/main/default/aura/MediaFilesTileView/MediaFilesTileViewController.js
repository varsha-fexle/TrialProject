({
    //handle page on load 
    doInit: function(component, event, helper) {
        
        //set spinner time-out
        setTimeout(function() {
            component.set("v.spinnerVisiblity", "false");
        }, 2000);
    },
    
    //handle play event button on audio tag
    handlePlay : function(component, event, helper) {
        
        helper.handlePlay(component, event, helper);
    },
    
    //redirect to media files record page
    redirectToSobject: function (component, event, helper) {
        
        var recordId = event.currentTarget.id;
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId,
            "slideDevName": "Detail"
        });
        navEvt.fire();
    },
    
    //handle image on click
    handleImgClick: function (component, event, helper) {
        
        var tempFiles = [], currentIndex = event.currentTarget.id, files = component.get('v.mediaFiles');
        
        tempFiles.push(files[currentIndex]);
        for(let i in files) {
            
            if( currentIndex != i)
                tempFiles.push(files[i]);
        }
        component.set("v.imagesDetail", tempFiles);   
        component.set("v.isModalOpen", 'true');
        
    },
    
    //handle modal cancel button click
    handleCancel: function (component, event, helper) {
        component.set("v.isModalOpen", 'false'); 
    },
    
})
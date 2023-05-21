({
    //handle page on load 
    doInit: function(component, event, helper) {
        
        if( component.get('v.mediaFiles').length == 0 && component.get('v.selectedSobject') != undefined && component.get('v.selectedSobject') != '') {
            helper.getSelectedObjLabel(component, event, helper, component.get('v.selectedSobject'));
            helper.doInit(component, event, helper, 'All');
        }
        
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
    
    //handle stateful button click
    handleViewClick: function (component, event, helper) {
        
        component.set('v.isTileView', !component.get('v.isTileView'));
        component.set('v.isListView', !component.get('v.isListView'));
        
    },
    
    //handle button menu select 
    handleSelect: function (component, event, helper) {
        // This will contain the value of the selected lightning:menuItem
        var selectedMenuItemValue = event.getParam("value");
        
        // Find all menu items
        var menuItems = component.find("menuItems");
   
        // Get the selected menu item
        menuItems.find(function(menuItem) {  
            if( menuItem.get("v.checked") == true && menuItem.get("v.value") != selectedMenuItemValue)
                menuItem.set("v.checked", !menuItem.get("v.checked"));
            
            if( menuItem.get("v.checked") == false && menuItem.get("v.value") == selectedMenuItemValue) {
                
                menuItem.set("v.checked", !menuItem.get("v.checked"));
                component.set("v.spinnerVisiblity", "true");
                
                component.set("v.checkedMenu", menuItem.get("v.value"));
                helper.doInit(component, event, helper, menuItem.get("v.value"));
                
            }
            
        });
    },
    handleNavigation: function (component, event, helper) {

        //before navigation stop played file
        helper.handlePlay(component, event, helper);
        //navigate to lightning page
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:AllMediaFiles",
            componentAttributes: {
                recordId				:	component.get("v.recordId"),
                mediaFilesLength		:	component.get('v.mediaFilesLength'),
                mediaFiles				:	component.get("v.mediaFiles"),
                sObjectName				:	component.get("v.sObjectName"),
                selectedSobject			:	component.get('v.selectedSobject'),
                selectedSobjectLabel	:	component.get('v.selectedSobjectLabel'),
                checkedMenu				:	component.get("v.checkedMenu")
            }
        });
        evt.fire();
    },
    
})
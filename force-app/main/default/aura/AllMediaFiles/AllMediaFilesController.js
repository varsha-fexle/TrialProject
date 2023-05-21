({
    //handle page on load
    doInit: function(component, event, helper) {
        //set spinner time-out
        setTimeout(function() {
            component.set("v.spinnerVisiblity", "false");
        }, 2000);
        
        if( component.get('v.mediaFiles').length == 0 && component.get('v.selectedSobject') != undefined && component.get('v.selectedSobject') != '')
            helper.doInit(component, event, helper, 'All');
        
    },
    
    //handle play event button on audio tag
    handlePlay : function(component, event, helper) {
        
        helper.handlePlay(component, event, helper);
    },
    
    //redirect to open tab home page
    navToHomePage : function (component, event, helper) {
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": component.get("v.sObjectName")
        });
        homeEvent.fire();
    },
    
    //redirect to open record page again
    navToRecordPage: function (component, event, helper) {
        
        var recordId = component.get('v.recordId');
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId,
            "slideDevName": "Detail"
        });
        navEvt.fire();
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
    
    handleCancel: function (component, event, helper) {
        component.set("v.isModalOpen", 'false'); 
    },
    
    //handle button menu select 
    handleSelect: function (component, event, helper) {
        // This will contain the index (position) of the selected lightning:menuItem
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
    
    //handle stateful button click
    handleViewClick: function (component, event, helper) {
        
        component.set('v.isTileView', !component.get('v.isTileView'));
        component.set('v.isListView', !component.get('v.isListView'));
        
    },
    
})
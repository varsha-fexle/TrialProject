({
    doInit: function(component, event, helper) {
       
        //set spinner time-out
        setTimeout(function() {
            component.set("v.spinnerVisiblity", "false");
        }, 2000);
        
        helper.doInit(component, event, helper);
    },
    
    openModel: function(component, event, helper) {


        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.showSobjects",true);
        component.set('v.searchedObjectValue',"");

		component.set("v.objectAPIName", "");
        component.set("v.selectedParentObj", "");
        component.set("v.selectedTitle", "");
        component.set("v.selectedURL", "");
        component.set("v.selectedType", "");
        component.set("v.selectedSize", "");
        component.set("v.active", "true");
        component.set('v.fields',[]);
        
        component.set("v.isOpen", "true");
    },
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", "false");
    },
    
    save: function(component, event, helper) {
        var selectedParentObj =  component.get("v.selectedParentObj"), selectedURL = component.get("v.selectedURL"), selectedType = component.get("v.selectedType");
        
        if(selectedURL == "" || selectedParentObj == "" || selectedType == "")
            helper.showToast(component, event, helper, "Warning", "Please Fill all the required fields.");
        
        else {
            
            component.set("v.isOpen", false);
            component.set("v.spinnerVisiblity", "true");
            helper.saveConfiguredObject(component, event, helper);
        } 
    },
    
    handleChange: function(component, event, helper) {
        
        var selectedOptionValue = event.getParam("value");
        
        component.set("v.modalSpinnerVisiblity", "true");
        
        component.set("v.objectAPIName", "");
        component.set("v.selectedParentObj", "");
        component.set("v.selectedTitle", "");
        component.set("v.selectedURL", "");
        component.set("v.selectedType", "");
        component.set("v.selectedSize", "");
        component.set("v.active", "true");
        
        component.set("v.objectAPIName",selectedOptionValue);
        
        helper.getFields(component, event, helper, selectedOptionValue);
    },
    handleClick : function(component, event, helper) {
        
        var selectedOptionValue = event.target.title;
        component.set("v.showSobjects",false);
        component.set('v.searchedObjectValue',selectedOptionValue);
        component.set("v.modalSpinnerVisiblity", "true");
        
        component.set("v.objectAPIName", "");
        component.set("v.selectedParentObj", "");
        component.set("v.selectedTitle", "");
        component.set("v.selectedURL", "");
        component.set("v.selectedType", "");
        component.set("v.selectedSize", "");
        component.set("v.active", "true");
        
        component.set("v.objectAPIName",selectedOptionValue);
        
        helper.getFields(component, event, helper, selectedOptionValue);

    },

    handleParentObjChange: function(component, event, helper) {
        var selectedParentObj = event.getParam("value");
        component.set("v.selectedParentObj", selectedParentObj);
    },
    
    handleFileTitleChange: function(component, event, helper) {
        var selectedTitle = event.getParam("value");
        component.set("v.selectedTitle", selectedTitle);
    },
    
    
    handleFileURLChange: function(component, event, helper) {
        var selectedURL = event.getParam("value");
        component.set("v.selectedURL", selectedURL);
    },
    
    
    handleFileTypeChange: function(component, event, helper) {
        var selectedType = event.getParam("value");
        component.set("v.selectedType", selectedType);
    },
    
    handleFileSizeChange: function(component, event, helper) {
        
        var selectedSize = event.getParam("value");
        component.set("v.selectedSize", selectedSize);
    },
    
    handleEdit: function(component, event, helper) {
        
        var recId = event.getParam('row').Id;
        var actionName = event.getParam('action').name;
        if ( actionName == 'edit_record' ) {
            
            component.set("v.editRecordId",recId);
            helper.editRecord(component, event, helper, recId);
        }
    },

    searchSalesforceObject : function (component,event,helper) {

        var successLabel = $A.get("$Label.c.Success");
        var searchObjectValue = document.getElementById("searchObject").value;
        if(searchObjectValue.length == 0) {
            component.set("v.showSobjects",true);
            component.set("v.objects",component.get("v.allObjects"));
        }
        var action = component.get("c.getSobjects");
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === successLabel) {
                if(response.getReturnValue().isSuccess) {

                    var sObjectList = [];
                    var sortedSObjectList = [];
                    const arrOfObjectValues = [];
                    sObjectList = response.getReturnValue().body.sobjects;
                    for(let i=0;i<sObjectList.length;i++) {
                        if((sObjectList[i].label).indexOf(searchObjectValue) !=-1) {
                            arrOfObjectValues[i] = sObjectList[i].value;
                            arrOfObjectValues[i] = arrOfObjectValues[i].toUpperCase();
                        }
                       
                    }
                    arrOfObjectValues.sort();
                    for(let j=0;j<arrOfObjectValues.length;j++) {
                        for(let k=0;k<sObjectList.length;k++) {
                            if(arrOfObjectValues[j] == (sObjectList[k].value).toUpperCase()) {
                                sortedSObjectList.push({label : sObjectList[k].label, value : sObjectList[k].value});
                            }
                        }
                    }
                    component.set('v.objects',sortedSObjectList);
                    component.set('v.data', response.getReturnValue().body.mediaFileObjectSettings);
                }
                else {
                    helper.showToast(component, event, helper, response.getReturnValue().status, response.getReturnValue().message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    handleDropdownClick : function (component,event,helper) { 
        component.set("v.showSobjects",!component.get("v.showSobjects"));
    }
})
({
    //call on component load
    doInit: function(component, event, helper) {

        var successLabel = $A.get("$Label.c.Success");
        //set spinner time-out
        setTimeout(function() {
            component.set("v.spinnerVisiblity", "false");
        }, 2000);
        
        component.set('v.columns', [
            {label: 'Object Name', fieldName: 'Object_Label__c', type: 'text'},
            {label: 'Parent Name', fieldName: 'Parent_Field_Label__c', type: 'text'},
            {label: 'Name', fieldName: 'Name_Field_Label__c', type: 'text'},
            {label: 'URL', fieldName: 'Source_URL_Field_Label__c', type: 'text'},
            {label: 'File Type', fieldName: 'File_Type_Field_Label__c', type: 'text'},
            {label: 'File Size', fieldName: 'File_Size_Field_Label__c', type: 'text'},
            {label: 'Active', fieldName: 'Active__c', type: 'boolean'},
            {label: 'Action', type: 'button', typeAttributes:
             { label: { fieldName: 'actionLabel'}, title: 'Click to Edit', name: 'edit_record', iconName: 'utility:edit'}}
        ]);
        
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
                        arrOfObjectValues[i] = sObjectList[i].value;
                        arrOfObjectValues[i] = arrOfObjectValues[i].toUpperCase();
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
                    component.set('v.allObjects ',sortedSObjectList);
                    component.set('v.data', response.getReturnValue().body.mediaFileObjectSettings);
                }
                else {
                    helper.showToast(component, event, helper, response.getReturnValue().status, response.getReturnValue().message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    
    getFields: function(component, event, helper, selectedOptionValue) {
        
        //set spinner time-out
        setTimeout(function() {
            component.set("v.modalSpinnerVisiblity", "false");
        }, 2000);
        
        var action = component.get("c.getSobjectFields");
        
        action.setParams({ "sObjectName" : selectedOptionValue});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue().isSuccess) {
                    
                    component.set('v.fields',response.getReturnValue().body);
                    
                }
                else {
                    helper.showToast(component, event, helper, response.getReturnValue().status, response.getReturnValue().message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    saveConfiguredObject: function(component, event, helper) {
        
        var configuredObjDetails, data = component.get('v.fields'), obj = component.get('v.objects');
        var parentObjLabel ={"label":"", "value": ""}, titleLabel = {"label":"", "value": ""}, typeLabel = {"label":"", "value": ""}, urlLabel = {"label":"", "value": ""}, sizeLabel = {"label":"", "value": ""};
        var objLabel = obj.find(function(item, i) {
            if(component.get("v.selectedParentObj") != '' && item.value === component.get("v.objectAPIName")){
                return item;
            }
            
        });
        
        //get label according to selected values
        data.find(function(item, i) {
            if(component.get("v.selectedParentObj") != '' && item.value === component.get("v.selectedParentObj"))
                parentObjLabel = item;
            
            if(component.get("v.selectedTitle") != '' && item.value === component.get("v.selectedTitle"))
                titleLabel = item;
            if(component.get("v.selectedURL") != '' && item.value === component.get("v.selectedURL"))
                urlLabel = item;
            if(component.get("v.selectedType") != '' && item.value === component.get("v.selectedType"))
                typeLabel = item;
            if(component.get("v.selectedSize") != '' && item.value === component.get("v.selectedSize"))
                sizeLabel = item;
        });
       
        if(component.get("v.editRecordId") != '')
            configuredObjDetails = {
                "Id"								:	component.get("v.editRecordId"),
                "Object_API_Name__c"			:	component.get("v.objectAPIName"),
                "Object_Label__c"				:	objLabel.label,
                "Parent_Field_API_Name__c"		:	component.get("v.selectedParentObj"),
                "Parent_Field_Label__c"		:	parentObjLabel.label,
                "Name_Field_API_Name__c"		:	component.get("v.selectedTitle"),
                "Name_Field_Label__c"			:	titleLabel.label,
                "Source_URL_Field_API_Name__c"	:	component.get("v.selectedURL"),
                "Source_URL_Field_Label__c"	:	urlLabel.label,
                "File_Type_Field_API_Name__c"	:	component.get("v.selectedType"),
                "File_Type_Field_Label__c"		:	typeLabel.label,
                "File_Size_Field_API_Name__c"	:	component.get("v.selectedSize"),
                "File_Size_Field_Label__c"		:	sizeLabel.label,
                "Active__c"					:	component.get("v.active")
            };
        else
            configuredObjDetails = {
                "Object_API_Name__c"			:	component.get("v.objectAPIName"),
                "Object_Label__c"				:	objLabel.label,
                "Parent_Field_API_Name__c"		:	component.get("v.selectedParentObj"),
                "Parent_Field_Label__c"		:	parentObjLabel.label,
                "Name_Field_API_Name__c"		:	component.get("v.selectedTitle"),
                "Name_Field_Label__c"			:	titleLabel.label,
                "Source_URL_Field_API_Name__c"	:	component.get("v.selectedURL"),
                "Source_URL_Field_Label__c"	:	urlLabel.label,
                "File_Type_Field_API_Name__c"	:	component.get("v.selectedType"),
                "File_Type_Field_Label__c"		:	typeLabel.label,
                "File_Size_Field_API_Name__c"	:	component.get("v.selectedSize"),
                "File_Size_Field_Label__c"		:	sizeLabel.label,
                "Active__c"					:	component.get("v.active")
            };
        var action = component.get("c.saveConfiguredObjectDetails");
        action.setParams({ "fileSettingDetails" : JSON.stringify(configuredObjDetails)});
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue().isSuccess) {
                    component.set("v.editRecordId","");
                    helper.showToast(component, event, helper, response.getReturnValue().status, response.getReturnValue().message);
                    helper.doInit(component, event, helper);
                }
                else {
                    component.set("v.spinnerVisiblity", "false");
                    helper.showToast(component, event, helper, response.getReturnValue().status, response.getReturnValue().message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    editRecord: function(component, event, helper, recordId) {
        
        var action = component.get("c.editConfigObjDetails");
        
        action.setParams({ "recordId" : recordId});
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue().isSuccess) {
                    
                    
                    var result = response.getReturnValue().body;
                    component.set("v.objectAPIName", result[0].Object_API_Name__c);
                    component.set("v.selectedParentObj", result[0].Parent_Field_API_Name__c);
                    component.set("v.selectedTitle", result[0].Name_Field_API_Name__c);
                    component.set("v.selectedURL", result[0].Source_URL_Field_API_Name__c);
                    component.set("v.selectedType", result[0].File_Type_Field_API_Name__c);
                    component.set("v.selectedSize", result[0].File_Size_Field_API_Name__c);
                    component.set("v.active", result[0].Active__c);
                    helper.getFields(component, event, helper, result[0].Object_API_Name__c);
                    component.set("v.isOpen", "true");
                }
                else {
                    helper.showToast(component, event, helper, response.getReturnValue().status, response.getReturnValue().message);
                }
            }
        });
        $A.enqueueAction(action);
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
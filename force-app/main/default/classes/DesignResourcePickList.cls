/**
* Description	: 	This controller created to get all configured sobject label and api name from Media_Files_Object_Setting__c for lightning component design.
* 
* Created Date  : 	06/03/2020
* 
* Created By	: 	Nikita Kumari
* 
* Revision Logs :   v_1.0 Created
**/
global class DesignResourcePickList extends VisualEditor.DynamicPickList {
    
    //for getting record page details like sObject name
    VisualEditor.DesignTimePageContext context;

    //This method get info about Lightning page is associated with.
    global DesignResourcePickList(VisualEditor.DesignTimePageContext context) {
       this.context = context;
    }
    
    /**
    * Description	: 	This method set default value in design attribute.
    * 
    * Params		: 	None
    * 
    * Return		:   VisualEditor.DataRow (Picklist values of design attribute)
    **/
    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow(Constants.SOBJECT_NAME_NOTES_AND_ATTACHMENTS, Constants.SOBJECT_NAME_NOTES_AND_ATTACHMENTS);
        return defaultValue;
    }
    
    /**
    * Description	: 	This method get all configured sobject label and api name from Media_Files_Object_Setting__c.
    * 
    * Params		: 	None
    * 
    * Return		:   VisualEditor.DataRow (Picklist values of design attribute)
    **/
    global override VisualEditor.DynamicPickListRows getValues() {
                
        VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
        
        myValues.addRow(new VisualEditor.DataRow(Constants.SOBJECT_NAME_NOTES_AND_ATTACHMENTS, Constants.SOBJECT_NAME_NOTES_AND_ATTACHMENTS));
        
        //get all active config sObjects
        for(Media_Files_Object_Setting__c objectInstance : [Select Object_Label__c, Object_API_Name__c From Media_Files_Object_Setting__c 
                                                            Where Parent_Field_Object_API_Name__c =: context.entityName AND Active__c = true 
                                                            WITH SECURITY_ENFORCED]){
            
            myValues.addRow(new VisualEditor.DataRow(objectInstance.Object_Label__c, objectInstance.Object_API_Name__c));
        }
        
        return myValues;
    }
}
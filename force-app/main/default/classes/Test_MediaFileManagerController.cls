/**
* Description	: 	This apex test class test all use cases of MediaFileManagerController apex class.
*
* Created by	: 	Nikita Kumari
*
* Created Date  : 	06/05/2020
*
* Revision Logs :   v_1.0 Created
*
* Coverage	    : 	92%
**/
@isTest
public class Test_MediaFileManagerController {

    /** 
    *	Description   :	This method inserts/holds the test data
	*
    *	@argument	  :	none
	*
    *	Revision Logs : V_1.0 - Created
    **/
    @TestSetup
    static void setupTestData(){
        
        Media_Files_Object_Setting__c mfos = new Media_Files_Object_Setting__c( Object_API_Name__c = 'Account', Object_Label__c = 'Account', Parent_Field_Object_API_Name__c = 'Account', Parent_Field_API_Name__c = 'ParentId', Parent_Field_Label__c = 'Parent Account',
                                                                               Name_Field_API_Name__c = 'Name', Name_Field_Label__c = 'Account Name', Source_URL_Field_Label__c = 'Website', Source_URL_Field_API_Name__c = 'Website',
                                                                               File_Type_Field_API_Name__c = 'Type', File_Type_Field_Label__c = 'Type', Active__c = true );
        Insert mfos;
        
    }
    
    /** 
    *	Description	:	This method test all method of MediaFileManagerController
	*
    *	Params		:	None
	*
    *	Return		:   None
    **/
    static testmethod void test_allMediaFileManagerControllerMethods(){
        
        Test.startTest();
        
        ResponseUtility actualResponse = new ResponseUtility();
        actualResponse = MediaFileManagerController.getSObjects();
        
        System.assertEquals(true, actualResponse.isSuccess);
        
        actualResponse = MediaFileManagerController.getSobjectFields('Account');
        System.assertEquals(true, actualResponse.isSuccess);
        
        actualResponse = MediaFileManagerController.getSobjectFields('  ');
        System.assertEquals(true, actualResponse.isSuccess);
        
        actualResponse = MediaFileManagerController.getSobjectFields('');
        System.assertEquals(true, actualResponse.isSuccess);
        
        //create JSON
        Map<String, Object> settingObj = new Map<String, Object>();
        
        actualResponse = MediaFileManagerController.saveConfiguredObjectDetails( JSON.Serialize(settingObj));
        System.assert(true, actualResponse.message.contains('Error::'));
        
        settingObj.put('Object_API_Name__c', 'Account');
        settingObj.put('Object_Label__c', 'Account');
        settingObj.put('Parent_Field_API_Name__c', 'ParentId');
        settingObj.put('Parent_Field_Label__c', 'Parent Account');
        settingObj.put('Parent_Field_Object_API_Name__c', 'Account');
        settingObj.put('Name_Field_API_Name__c', 'Name');
        settingObj.put('Name_Field_Label__c', 'Account Name');
        settingObj.put('Source_URL_Field_Label__c', 'Website');
        settingObj.put('File_Type_Field_API_Name__c', 'Type');
        settingObj.put('File_Type_Field_Label__c', 'Type');
        settingObj.put('Source_URL_Field_API_Name__c', 'Website');
        settingObj.put('Active__c', true);
        
        actualResponse = MediaFileManagerController.saveConfiguredObjectDetails( JSON.serialize(settingObj) );
        
        System.assertEquals(true, actualResponse.message.contains(Constants.WARNING_MESSAGE_FOR_EXISTING_MEDIA_SETTING));
        System.assertEquals(false, actualResponse.isSuccess);
                
        
        Media_Files_Object_Setting__c mfos = [Select Id From Media_Files_Object_Setting__c limit 1];
        
        settingObj.put('Id', mfos.Id);
        actualResponse = MediaFileManagerController.saveConfiguredObjectDetails( JSON.serialize(settingObj) );
        
        System.assert(true, actualResponse.message.contains(Constants.SUCCESS_MESSAGE_AFTER_MEDIA_SETTING_UPDATED));
        
        actualResponse = MediaFileManagerController.editConfigObjDetails( mfos.Id );
        System.assertEquals(true, actualResponse.isSuccess);
        
        actualResponse = MediaFileManagerController.editConfigObjDetails( null );
        System.assertEquals(true, actualResponse.isSuccess);
        
        settingObj = new Map<String, Object>();
        
        settingObj.put('Object_API_Name__c', 'Contact');
        settingObj.put('Object_Label__c', 'Contact');
        settingObj.put('Parent_Field_API_Name__c', 'AccountId');
        settingObj.put('Parent_Field_Label__c', 'Account Name');
        settingObj.put('Name_Field_API_Name__c', 'Name');
        settingObj.put('Name_Field_Label__c', 'Name');
        settingObj.put('Source_URL_Field_Label__c', 'AssistantName');
        settingObj.put('Source_URL_Field_API_Name__c', 'Assistant');
        settingObj.put('Active__c', true);
        
        actualResponse = MediaFileManagerController.saveConfiguredObjectDetails( JSON.serialize(settingObj) );
        System.assert(true, actualResponse.message.contains(Constants.SUCCESS_MESSAGE_AFTER_MEDIA_SETTING_INSERTED));
        
        Test.stopTest();
    }
}
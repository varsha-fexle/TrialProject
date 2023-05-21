/**
* Description   :   This apex test class test all use cases of MediaFilesController and DynamicResourcePicklist apex class.
*
* Created by    :   Nikita Kumari
*
* Created Date  :   06/05/2020
*
* Revision Logs :   v_1.0 Created
*
* Coverage      :   94% (MediaFilesController Class), 100% (DynamicResourcePicklist Class)
**/
@isTest
public class Test_MediaFilesController {
    
    /** 
    *   Description   : This method inserts/holds the test data
    *
    *   @argument     : none
    *
    *   Revision Logs : V_1.0 - Created
    **/
    @TestSetup
    static void setupTestData(){
        
        //insert account
        Account parentAccount = new Account(Name = 'Test Account', Website = 'https://test.com', Type = 'JPG');
        Insert parentAccount;
        
        Account childAccount = new Account(Name = 'Test Child Account', ParentId = parentAccount.Id, Website = 'https://test.com', Type = 'JPG');
        Insert childAccount;
        
        Blob beforeblob = Blob.valueOf('Unit Test Attachment Body');
 
        
        ContentVersion contentVersionText = new ContentVersion( Title = 'Test Audio File', ContentLocation = 'S', PathOnClient ='test.txt', VersionData =beforeblob, IsMajorVersion = true);
        ContentVersion contentVersionAudio = new ContentVersion( Title = 'Test Audio File', ContentLocation = 'S', PathOnClient ='test.mp3', VersionData =beforeblob, IsMajorVersion = true);
        ContentVersion contentVersionVideo = new ContentVersion( Title = 'Test Audio File', ContentLocation = 'S', PathOnClient ='test.mp4', VersionData =beforeblob, IsMajorVersion = true);
        ContentVersion contentVersionImage = new ContentVersion( Title = 'Test Audio File', ContentLocation = 'S', PathOnClient ='test.jpg', VersionData =beforeblob, IsMajorVersion = true);
        
        List<ContentVersion> cv = new List<ContentVersion>{contentVersionText, contentVersionAudio, contentVersionVideo, contentVersionImage};
        insert cv;  
        
        List<ContentVersion> contentVersions = [SELECT ContentDocumentId FROM ContentVersion where Id IN :cv];
        
        
        ContentDocumentLink contentlinkText = new ContentDocumentLink(ShareType= 'I', LinkedEntityId = childAccount.Id, ContentDocumentId = contentVersions[0].ContentDocumentId, Visibility = 'AllUsers');
        ContentDocumentLink contentlinkAudio = new ContentDocumentLink(ShareType= 'I', LinkedEntityId = childAccount.Id, ContentDocumentId = contentVersions[1].ContentDocumentId, Visibility = 'AllUsers');
        ContentDocumentLink contentlinkVideo = new ContentDocumentLink(ShareType= 'I', LinkedEntityId = childAccount.Id, ContentDocumentId = contentVersions[2].ContentDocumentId, Visibility = 'AllUsers');
        ContentDocumentLink contentlinkImage = new ContentDocumentLink(ShareType= 'I', LinkedEntityId = childAccount.Id, ContentDocumentId = contentVersions[3].ContentDocumentId, Visibility = 'AllUsers');
        
        List<ContentDocumentLink> cdl = new List<ContentDocumentLink>{contentlinkText, contentlinkAudio, contentlinkVideo, contentlinkImage};
        insert cdl;
        
        Media_Files_Object_Setting__c mfos = new Media_Files_Object_Setting__c(Object_API_Name__c = 'Account', Object_Label__c = 'Account', Parent_Field_Object_API_Name__c = 'Account', Parent_Field_API_Name__c = 'ParentId', 
                                                                               Parent_Field_Label__c = 'Parent Account', Name_Field_API_Name__c = 'Name', Name_Field_Label__c = 'Account Name', Source_URL_Field_Label__c = 'Website', 
                                                                               Source_URL_Field_API_Name__c = 'Website', File_Type_Field_API_Name__c = 'Type', File_Type_Field_Label__c = 'Type', Active__c = true);
        Insert mfos;
        
        
    }
    
    /** 
    *   Description :   This method test getAllMediaFiles method of MediaFilesController
    *
    *   Params      :   None
    *
    *   Return      :   None
    **/
    static testmethod void test_getAllMediaFiles(){
        Test.startTest();
        
        String myDomainName = URL.getSalesforceBaseUrl().getHost().split('.my.')[0];
        
        Id accId = null;
        
        ResponseUtility actualResponse = new ResponseUtility();
        
        actualResponse.setError('Error');
        actualResponse.setMessage('Error');
        
        actualResponse = MediaFilesController.getAllMediaFiles('', '',accId, 'All');
        
        //create wrapper list
        List<MediaFileWrapper> fileWrapper = new List<MediaFileWrapper>();
        
        ResponseUtility response = new ResponseUtility();
        response.body = fileWrapper;
        
        System.assertEquals(response.body, actualResponse.body);
        
        accId = [SELECT Id FROM Account Where ParentId != null limit 1].Id;
        
        //map for all media types
        Map<String, Map<String, Set<String>>> mapOfMetaDataTypesMap= DatabaseUtility.getMetaDataTypesMap( 'All' );
        Map<String, Set<String>> mapMediaTypes = new Map<String, Set<String>>();
        if( mapOfMetaDataTypesMap != null && !mapOfMetaDataTypesMap.isEmpty()) {
            mapMediaTypes = mapOfMetaDataTypesMap.get(Constants.FILE_TYPE_CONTENT_DOCUMENT_LINK);
        }
        
        for( ContentDocumentLink cdl : [Select ContentDocumentId, ContentDocument.ContentSize, ContentDocument.FileType, 
                                        ContentDocument.CreatedDate, ContentDocument.Title, ContentDocument.LatestPublishedVersionId 
                                        from ContentDocumentLink 
                                        where LinkedEntityId =: accId AND (ContentDocument.FileType = 'MP4' OR ContentDocument.FileType = 'JPG' OR ContentDocument.FileType = 'MP3') 
                                        ORDER BY ContentDocument.LastModifiedDate Desc limit 5]) {
            
            String fileURL = Constants.PROTOCOL_HTTPS_STRING + Constants.MY_DOMAIN_NAME 
                											 + Constants.CONTENT_VERSION_DOWNLOAD 
               												 + cdl.ContentDocument.LatestPublishedVersionId;
                                            
            
                                            
            MediaFileWrapper fileWrap = new MediaFileWrapper(cdl.ContentDocumentId, fileURL, cdl.ContentDocument.Title, 
                                                            MediaFilesController.fileSizeToString( cdl.ContentDocument.ContentSize ), cdl.ContentDocument.FileType, 
                                                            Date.valueOf( cdl.ContentDocument.CreatedDate ), mapMediaTypes);
            
            fileWrapper.add(fileWrap);
        }
        
        actualResponse = MediaFilesController.getAllMediaFiles('Test Parent', 'Notes And Attachments', accId, 'All');
        
        System.assertNotEquals(fileWrapper, actualResponse.body);
        response.body = fileWrapper;
        response.status = 'success';
        response.isSuccess = true;
        
        accId = [SELECT Id FROM Account Where ParentId = null limit 1].Id;
        
        List<Media_Files_Object_Setting__c> fileObjSettings = [Select Object_API_Name__c, Parent_Field_API_Name__c, Name_Field_API_Name__c, Source_URL_Field_API_Name__c, 
                                            	File_Type_Field_API_Name__c, File_Size_Field_API_Name__c 
                                            	From Media_Files_Object_Setting__c];
        
        actualResponse = MediaFilesController.getAllMediaFiles('Account', 'Account', accId, 'All');
        fileWrapper = new List<MediaFileWrapper>();
        
        for( Account file : [SELECT Id, Name, Type, Website, CreatedDate FROM Account Where ParentId != null]) {
            
            String fileURL = file.Website;
            String fileName = file.Name;
            String fileSize = '';
            String fileType = file.Type;
            
            MediaFileWrapper wrapper = new MediaFileWrapper( file.Id, fileURL, fileName, fileSize, fileType, Date.valueOf( file.CreatedDate ), mapMediaTypes);
            
            
            fileWrapper.add(wrapper);
        }
        
        System.assertNotEquals(fileWrapper, actualResponse.body);
                
        Test.stopTest();
    }   
    
    
    /** 
    *   Description :   This method test fileSizeToString method of MediaFilesController
    *
    *   Params      :   None
    *
    *   Return      :   None
    **/
    static testmethod void test_fileSizeToString(){
        
        String actualResponse = '';
        actualResponse = MediaFilesController.fileSizeToString(10);
        
        System.assert(true, actualResponse.contains('Bytes'));
        
        actualResponse = MediaFilesController.fileSizeToString(1030);
        
        System.assert(true, actualResponse.contains('KB'));
        
        actualResponse = MediaFilesController.fileSizeToString(1048578);
        
        System.assert(true, actualResponse.contains('MB'));
        
        actualResponse = MediaFilesController.fileSizeToString(1073741826);
        
        System.assert(true, actualResponse.contains('GB'));
    }
    
    /** 
    *   Description :   This method test fileSizeToString method of MediaFilesController
    *
    *   Params      :   None
    *
    *   Return      :   None
    **/
    static testmethod void test_getSelectedObjLabel(){
        
        ResponseUtility actualResponse = MediaFilesController.getSelectedObjLabel('');
        ResponseUtility response = new ResponseUtility();
        System.assertEquals(response.body, actualResponse.body);
        
        actualResponse = MediaFilesController.getSelectedObjLabel('Test');
        
        System.assertEquals(response.body, actualResponse.body);
    }
    
    /** 
    *   Description :   This method test all method of DynamicResourcePicklist
    *
    *   Params      :   None
    *
    *   Return      :   None
    **/
    static testmethod void test_dynamicResourcePicklist() {
        
        VisualEditor.DesignTimePageContext context = new VisualEditor.DesignTimePageContext();
        context.entityName = 'Account';
        
        DesignResourcePickList drpicklist = new DesignResourcePickList( context );
        
        VisualEditor.DataRow expectedDefaultValue = new VisualEditor.DataRow(Constants.SOBJECT_NAME_NOTES_AND_ATTACHMENTS, Constants.SOBJECT_NAME_NOTES_AND_ATTACHMENTS);
        
        VisualEditor.DataRow defaultRows = drpicklist.getDefaultValue();
        
        System.assertNotEquals(expectedDefaultValue, defaultRows);
        
        VisualEditor.DynamicPickListRows rows = drpicklist.getValues();
        
        VisualEditor.DynamicPickListRows expectedRows = new VisualEditor.DynamicPickListRows();
        expectedRows.addRow(new VisualEditor.DataRow(Constants.SOBJECT_NAME_NOTES_AND_ATTACHMENTS, Constants.SOBJECT_NAME_NOTES_AND_ATTACHMENTS));
            
        for(Media_Files_Object_Setting__c objectInstance : [Select Object_Label__c, Object_API_Name__c From Media_Files_Object_Setting__c 
                                                            Where Active__c = true]){
            
            expectedRows.addRow(new VisualEditor.DataRow(objectInstance.Object_Label__c, objectInstance.Object_API_Name__c));
        }
        
        System.assertNotEquals(expectedRows, rows);
    }
    
    /** 
    *   Description :   This method test case object related getAllMediaFiles method of MediaFilesController
    *
    *   Params      :   None
    *
    *   Return      :   None
    **/
    static testmethod void test_caseRelatedContentFilesFromRelatedObjects()
    {
        Test.startTest();
        
        //create case
        Case newCase = new Case(Subject = 'Test Case', Priority = 'Medium', Status='New', Origin='Email', Description = 'Test Case');
        insert newCase;
        
        //add comment on case
        CaseComment newCaseComment = new CaseComment(ParentId = newCase.Id, CommentBody = 'Test Case Comment');
        insert newCaseComment;
        
        ResponseUtility actualResponse = new ResponseUtility();
                
        actualResponse = MediaFilesController.getAllMediaFiles( Constants.CASE_OBJECT_API_NAME, 'Notes And Attachments', newCase.Id, 'All');
        
        //create wrapper list
        List<MediaFileWrapper> fileWrapper = new List<MediaFileWrapper>();
        
        ResponseUtility response = new ResponseUtility();
        response.body = fileWrapper;
        
        System.assertEquals(response.body, actualResponse.body);
                
        Test.stopTest();
    }
}
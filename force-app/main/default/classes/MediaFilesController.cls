/**
* Description	: 	This controller created to get all media files from a specific sObject record.
* 
* Created Date  : 	05/25/2020
* 
* Created By	: 	Nikita Kumari
* 
* Revision Logs :   v_1.0 Created
    
    
**/
public with sharing class MediaFilesController {
    
    /**
    * Description	: 	This method gets all media files detail according to the selected sobject and applied filter.
    * 
    * Params		: 	String, String, Id, String
    * 
    * Return		:   ResponseUtility
    **/
    @AuraEnabled
    public static ResponseUtility getAllMediaFiles(String pageObjName,String selectedObjName, Id recordId, String mediaFileFilter){
        
       if(recordId !=null && String.isBlank(pageObjName)) {
             pageObjName = getSobjectName(recordId);
        }
        //initialization of response utility
        ResponseUtility response = new ResponseUtility();
        
        try{
            //list of media file wrapper
            List<MediaFileWrapper> mediaFiles = new List<MediaFileWrapper>();
            
            //check all params
            if( String.isNotBlank(pageObjName) && String.isNotBlank(selectedObjName) && recordId != null && String.isNotBlank(mediaFileFilter) ) {
                
                //map for all media types
                Map<String, Map<String, Set<String>>> mapOfMetaDataTypesMap= DatabaseUtility.getMetaDataTypesMap( mediaFileFilter );
                
                if( mapOfMetaDataTypesMap != null && !mapOfMetaDataTypesMap.isEmpty()) {
                    
                     //map for all media types
                    Map<String, Set<String>> mapMediaTypes = mapOfMetaDataTypesMap.get(Constants.FILE_TYPE_CONTENT_DOCUMENT_LINK);
                
                    //to hold the media type for attachments in media type/media file type for e.g. audio/mp3
                    Map<String, Set<String>> mapMediaTypesForAttachments = mapOfMetaDataTypesMap.get(Constants.FILE_TYPE_ATTACHMENT); 
                   
                    //for media file object setting details
                    List<Media_Files_Object_Setting__c> fileObjSettings = new List<Media_Files_Object_Setting__c>();
                    
                    //check selected Object is not attachment
                    if( selectedObjName != Constants.SOBJECT_NAME_NOTES_AND_ATTACHMENTS )
                        fileObjSettings = [Select Object_API_Name__c, Parent_Field_API_Name__c, Name_Field_API_Name__c, Source_URL_Field_API_Name__c, 
                                            File_Type_Field_API_Name__c, File_Size_Field_API_Name__c 
                                            From Media_Files_Object_Setting__c 
                                            Where Parent_Field_Object_API_Name__c =: pageObjName AND Object_API_Name__c =: selectedObjName AND Active__c = true limit 1];
                                            
                    //query for attachments
                    if( selectedObjName == Constants.SOBJECT_NAME_NOTES_AND_ATTACHMENTS ) {
                        
                        Set<Id> setOfLinkedEntityIds = new Set<Id>{recordId};
                        //Modified - 12/07/2022 - if the selected object/record Id is the case then also get the media files from the related email message and comments
                        //recordId.getSObjectType().getDescribe().getName().toUpperCase()
                        if(recordId != null && Constants.CASE_OBJECT_API_NAME == pageObjName.toUpperCase())
                        { 
                            //check email to case is enabled for system or not
                            List<EmailServicesFunction> emailToCaseServices = [SELECT Id, FunctionName from EmailServicesFunction 
                                                          					where FunctionName =: Constants.EMAIL_SERVICES_FUNCTION_EMAIL_TO_CASE AND IsActive = true];
                            
                            if(emailToCaseServices != null && !emailToCaseServices.isEmpty())
                            {
                                for(sObject emailMsg : database.query('Select Id, ParentId  From EmailMessage Where ParentId != null AND ParentId =\''+recordId+'\''))
                                {
                                    setOfLinkedEntityIds.add((Id)emailMsg.get('Id'));
                                }
                            }
                            
                            //get related case comments Ids
                            for(CaseComment caseCom : [Select Id, ParentId  From CaseComment Where ParentId != null AND ParentId =: recordId])
                            {
                                setOfLinkedEntityIds.add(caseCom.Id);
                            }
                        }
                        //get file content document
                        for(ContentDocumentLink cdl : [Select ContentDocumentId, ContentDocument.ContentSize, ContentDocument.FileType,
                                                        ContentDocument.CreatedDate, ContentDocument.Title, ContentDocument.LatestPublishedVersionId 
                                                        From ContentDocumentLink 
                                                        where LinkedEntityId IN: setOfLinkedEntityIds AND ContentDocument.FileType IN: mapMediaTypes.get(mediaFileFilter) 
                                                       	WITH SECURITY_ENFORCED
                                                        ORDER BY ContentDocument.LastModifiedDate Desc])
                        {
                                        
                            String fileURL = Constants.PROTOCOL_HTTPS_STRING + Constants.MY_DOMAIN_NAME 
                                                                             + Constants.CONTENT_VERSION_DOWNLOAD 
                                                                             + cdl.ContentDocument.LatestPublishedVersionId;
                                                            
                            MediaFileWrapper wrapper = new MediaFileWrapper(cdl.ContentDocumentId, fileURL, cdl.ContentDocument.Title, 
                                                                            fileSizeToString( cdl.ContentDocument.ContentSize ), cdl.ContentDocument.FileType.toUpperCase(), 
                                                                            Date.valueOf( cdl.ContentDocument.CreatedDate ), mapMediaTypes);
                            
                            mediaFiles.add(wrapper);
                        }
                        //get file from attachments
                        for(Attachment attachment : [SELECT Id, BodyLength, Name, ContentType, CreatedDate FROM Attachment
                                                     where ParentId IN: setOfLinkedEntityIds AND ContentType IN: mapMediaTypesForAttachments.get(mediaFileFilter) 
                                                     WITH SECURITY_ENFORCED
                                                     ORDER BY LastModifiedDate Desc]
                           )
                        {                 
                            String fileURL = Constants.PROTOCOL_HTTPS_STRING + Constants.MY_DOMAIN_NAME 
                                + Constants.ATTACHMENT_DOWNLOAD + attachment.Id;
                            
                            List<String> fileType = attachment.ContentType.split('/');
                            MediaFileWrapper wrapper = new MediaFileWrapper(attachment.Id, fileURL, attachment.Name, 
                                                                            fileSizeToString( attachment.BodyLength ), 
                                                                            (fileType != null ? (fileType.size() > 1 ? fileType[1].toUpperCase() : fileType[0].toUpperCase()) : ''), 
                                                                            Date.valueOf( attachment.CreatedDate ), mapMediaTypes);
                            
                            mediaFiles.add(wrapper);
                        }
                        
                }
                    
                    //query for configured sObject else
                    if( !fileObjSettings.isEmpty() ) {
                        
                        //loop over sObject 
                        for( sObject file : DatabaseUtility.getConfigSObjectDetails(fileObjSettings, recordId, mediaFileFilter, mapMediaTypes) ) {
                            
                            String fileURL = String.isNotBlank(fileObjSettings[0].Source_URL_Field_API_Name__c) ? String.valueOf( file.get(fileObjSettings[0].Source_URL_Field_API_Name__c) ) : '';
                            String fileName = String.isNotBlank(fileObjSettings[0].Name_Field_API_Name__c) ? String.valueOf( file.get(fileObjSettings[0].Name_Field_API_Name__c) ) : '';
                            String fileSize = String.isNotBlank(fileObjSettings[0].File_Size_Field_API_Name__c) ? String.valueOf( file.get(fileObjSettings[0].File_Size_Field_API_Name__c) ) : '';
                            String fileType = String.isNotBlank(fileObjSettings[0].File_Type_Field_API_Name__c) ? String.valueOf( file.get(fileObjSettings[0].File_Type_Field_API_Name__c) ).toUpperCase() : '';
                            
                            MediaFileWrapper wrapper = new MediaFileWrapper( file.Id, fileURL, fileName, fileSize, fileType, Date.valueOf( file.get('CreatedDate') ), mapMediaTypes);
                            
                            mediaFiles.add(wrapper);
                        }
                    }
                }
            }
            
            response.setBody(mediaFiles);
        }
        catch(Exception ex) {
            response.setError(Constants.ERROR_STRING + ex.getMessage());
        }
        
        return response;
    }
    
    /**
    * Description	: 	This method is used to find sObject Name by recordId.
    * 
    * Params		: 	Id
    * 
    * Return		:   String
    **/
    public static String getSobjectName(Id recordId) {
        Schema.SObjectType sObjType = recordId.getSobjectType();
        String sobj = ''+sObjType;
        return sobj;
    }
    
    /**
    * Description	: 	This method convert all audio files content size in bytes, KB, MB, and GB.
    * 
    * Params		: 	Integer
    * 
    * Return		:   String
    **/
    public static String fileSizeToString(Integer fileContentSize) {
        
        if (fileContentSize < Constants.ONE_KB_SIZE)
            return string.valueOf(fileContentSize) + Constants.BYTE_STRING;
        
        else if (fileContentSize >= Constants.ONE_KB_SIZE && fileContentSize < (Constants.ONE_KB_SIZE * Constants.ONE_KB_SIZE)) {
            
            Decimal kb = Decimal.valueOf(fileContentSize);
            kb = kb.divide(Constants.ONE_KB_SIZE, 0);
            
            return string.valueOf(kb) + Constants.KB_STRING;
        }
        else if (fileContentSize >= (Constants.ONE_KB_SIZE * Constants.ONE_KB_SIZE) && fileContentSize < (Constants.ONE_KB_SIZE * Constants.ONE_KB_SIZE * Constants.ONE_KB_SIZE)) {
            
            Decimal mb = Decimal.valueOf(fileContentSize);
            mb = mb.divide((Constants.ONE_KB_SIZE * Constants.ONE_KB_SIZE), 0);
            
            return string.valueOf(mb) + Constants.MB_STRING;
        }
        else {
            
            Decimal gb = Decimal.valueOf(fileContentSize);
            gb = gb.divide((Constants.ONE_KB_SIZE * Constants.ONE_KB_SIZE * Constants.ONE_KB_SIZE), 0);
            
            return string.valueOf(gb) + Constants.GB_STRING;
        }    
    }   
    
    /**
    * Description	: 	This method get selected sObject label from Media_Files_Object_Setting__c.
    * 
    * Params		: 	String
    * 
    * Return		:   ResponseUtility
    **/
    @AuraEnabled
    public static ResponseUtility getSelectedObjLabel(String selectedObjAPIName) {
        
        //initialization of response utility
        ResponseUtility response = new ResponseUtility();
        
        try {
            
            if( String.isNotBlank(selectedObjAPIName) ) {
                
                //get label
                String selectedObjLabel = [Select Object_Label__c From Media_Files_Object_Setting__c Where Object_API_Name__c =: selectedObjAPIName AND Active__c = true limit 1].Object_Label__c;
                
                response.setBody( selectedObjLabel != null ? selectedObjLabel : '') ;
            }
        }  
        
        catch(Exception ex) {
            response.setError(Constants.ERROR_STRING + ex.getMessage());
        }
        
        return response;
    }
    
}

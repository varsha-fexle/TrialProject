/**
* Description	: 	This controller created to get database.query result.
* 
* Created Date  : 	06/11/2020
* 
* Created By	: 	Nikita Kumari
* 
* Revision Logs :   v_1.0 Created
**/
public with sharing class DatabaseUtility {

    /**
    * Description	: 	This method get configured sObject details.
    * 
    * Params		: 	List, Id, String, Map
    * 
    * Return		:   ResponseUtility
    **/
    public static List<sObject> getConfigSObjectDetails( List<Media_Files_Object_Setting__c> fileObjSettings, Id recordId, String mediaFileFilter, Map<String, Set<String>> mapMediaTypes) {
     	
        List<sObject> fileConfigObjDetails = new List<sObject>();
        
        if(  fileObjSettings.size() > 0 && recordId != null && String.isNotBlank( mediaFileFilter ) && mapMediaTypes != null && !mapMediaTypes.isEmpty() ) {
            
            Set<String> mediaTypeValues = mapMediaTypes.get(mediaFileFilter);
            
            fileConfigObjDetails = database.query(SOQLQueryBuilder.createSobjectQueryString(fileObjSettings, recordId, mediaFileFilter));

        }
        
        return fileConfigObjDetails;
        
    }
    
    /**
    * Description	: 	This method get metadata media file type map.
    * 
    * Params		: 	String
    * 
    * Return		:   ResponseUtility
    **/
    public static Map<String, Map<String, Set<String>>> getMetaDataTypesMap( String mediaFileFilter ) {
     	
        //initialization of variables
        Map<String, Map<String, Set<String>>> mapMediaTypes = new Map<String, Map<String, Set<String>>>();
        //add keys in map
        mapMediaTypes.put(Constants.FILE_TYPE_ATTACHMENT, new Map<String, Set<String>>());
        mapMediaTypes.put(Constants.FILE_TYPE_CONTENT_DOCUMENT_LINK, new Map<String, Set<String>>());
        
        if( String.isNotBlank( mediaFileFilter ) ) {
            
            for( Media_Files_Type_Settings__mdt typeSetting : [SELECT Id, MasterLabel, Media_Type__c 
                                                                from Media_Files_Type_Settings__mdt Where MasterLabel != null 
                                                                WITH SECURITY_ENFORCED]
               )
            {
                
                //put values in map for files
                if(mapMediaTypes.containsKey(Constants.FILE_TYPE_CONTENT_DOCUMENT_LINK))
                {
                    //add audio/video/image media file type
                    if( !mapMediaTypes.get(Constants.FILE_TYPE_CONTENT_DOCUMENT_LINK).containsKey(typeSetting.Media_Type__c) )
                    {
                        mapMediaTypes.get(Constants.FILE_TYPE_CONTENT_DOCUMENT_LINK).put(typeSetting.Media_Type__c, new Set<String>());
                        System.debug('First');
                    }
                    mapMediaTypes.get(Constants.FILE_TYPE_CONTENT_DOCUMENT_LINK).get(typeSetting.Media_Type__c).add(typeSetting.MasterLabel.toUpperCase());
                    
                    //add all media file type
                    
                    if( !mapMediaTypes.get(Constants.FILE_TYPE_CONTENT_DOCUMENT_LINK).containsKey(Constants.ALL_STRING) )
                    {
                        mapMediaTypes.get(Constants.FILE_TYPE_CONTENT_DOCUMENT_LINK).put(Constants.ALL_STRING, new Set<String>());
                        System.debug('Second');
                    }
                    mapMediaTypes.get(Constants.FILE_TYPE_CONTENT_DOCUMENT_LINK).get(Constants.ALL_STRING).add(typeSetting.MasterLabel.toUpperCase());
                }
                
                //put values in map for attachments
                if(mapMediaTypes.containsKey(Constants.FILE_TYPE_ATTACHMENT))
                {
                    //add audio/video/image media file type
                    if( !mapMediaTypes.get(Constants.FILE_TYPE_ATTACHMENT).containsKey(typeSetting.Media_Type__c) )
                    {
                        mapMediaTypes.get(Constants.FILE_TYPE_ATTACHMENT).put(typeSetting.Media_Type__c, new Set<String>());
                        System.debug('Third');
                    }
                    mapMediaTypes.get(Constants.FILE_TYPE_ATTACHMENT).get(typeSetting.Media_Type__c).add(typeSetting.Media_Type__c+'/'+typeSetting.MasterLabel.toUpperCase());
                    
                    //add all media file type
                    
                    if( !mapMediaTypes.get(Constants.FILE_TYPE_ATTACHMENT).containsKey(Constants.ALL_STRING) )
                    {
                        mapMediaTypes.get(Constants.FILE_TYPE_ATTACHMENT).put(Constants.ALL_STRING, new Set<String>());
                        System.debug('Fourth');
                    }
                    mapMediaTypes.get(Constants.FILE_TYPE_ATTACHMENT).get(Constants.ALL_STRING).add(typeSetting.Media_Type__c+'/'+typeSetting.MasterLabel.toUpperCase());
                }
            }
        }
        
        return mapMediaTypes;
        
    }
    
}
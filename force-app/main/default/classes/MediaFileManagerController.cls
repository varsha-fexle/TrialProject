/**
* Description	: 	This controller get all Objects and their fields detail from org and insert/ update config object mapping on media file manager object.
* 
* Created Date  : 	05/29/2020
* 
* Created By	: 	Nikita Kumari
* 
* Revision Logs :   v_1.0 Created
*
**/
global with sharing class MediaFileManagerController{
    
    //for global describe call
    private static Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
    
    /**
    * Description	: 	This method gets all sObject details.
    * 
    * Params		: 	None
    * 
    * Return		:   ResponseUtility
    **/
    @AuraEnabled
    public static ResponseUtility getSobjects(){
        
        //initialization of response utility
        ResponseUtility response = new ResponseUtility();
        System.debug('@@@ 27 response '+response.isSuccess);
        
        try{
            
            MediaFileSettingWrap mfSettingWrap = new MediaFileSettingWrap();
            List<SobjectWrap> sObjWrapper = new List<SobjectWrap>();
            
            //for loop over sObjectType
            for(Schema.SObjectType obj : globalDescribe.values()) {
                
                String name = obj.getDescribe().getName();
                if(!obj.getDescribe().isCustomSetting() && obj.getDescribe().getRecordTypeInfos().size() > 0 && obj.getDescribe().isCreateable() &&
                   !name.containsignorecase(Constants.HISTORY) && !name.containsignorecase(Constants.TAG) && !name.containsignorecase(Constants.SHARE) && !name.containsignorecase(Constants.FEED)) {
                    //get sObject describe result
                    Schema.DescribeSObjectResult objResult = obj.getDescribe();
                    
                    if( !objResult.deprecatedandhidden && objResult.isAccessible() && !(Constants.POLYMORPIC_OBJECTS_CONST.contains(objResult.getName())) ) {
                        
                        //set data in sObject wrapper
                        SobjectWrap sObjWrap = new SobjectWrap(objResult.getName(), objResult.getLabel());
                        sObjWrapper.add(sObjWrap);
                    }
                
                }
            }
            //set list of sObject wrapper
            mfSettingWrap.sobjects = sObjWrapper;
            
            //get media file object settings details
            mfSettingWrap.mediaFileObjectSettings = [Select Id, Object_Label__c, Parent_Field_Label__c, Name_Field_Label__c, 
                                                        Source_URL_Field_Label__c, File_Type_Field_Label__c, File_Size_Field_Label__c, Active__c 
                                                        From Media_Files_Object_Setting__c WITH SECURITY_ENFORCED
                                                        order by createdDate Asc];
            response.setBody(mfSettingWrap);
            System.debug('61 response '+response.isSuccess);
        }
        
        catch(Exception ex) {
            
            response.setError( Constants.ERROR_STRING + ex.getMessage() );
        }
         System.debug('68 response '+response.isSuccess);
        return response;
        
    }
    
    /**
    * Description	: 	This method gets all fields detail of selected sObject.
    * 
    * Params		: 	String
    * 
    * Return		:   ResponseUtility
    **/
    @AuraEnabled
    public static ResponseUtility getSobjectFields(String sObjectName){
        
        ResponseUtility response = new ResponseUtility();
        
        try{
            
            List<FieldWrap> fieldWrapper = new List<FieldWrap>();
            
            if( String.isNotBlank(sObjectName) ) {
                 
                Schema.SObjectType sObjType = globalDescribe.get(sObjectName); 
                Map<String, Schema.SobjectField> fieldmap = sObjType.getDescribe().fields.getMap();   
                
                for(String fieldName: fieldmap.keySet()) {
                    
                    Schema.DescribeFieldResult desFieldResult = fieldmap.get(fieldName).getDescribe();
                    
                    if( desFieldResult.isAccessible() ) {
                        
                        FieldWrap wmp = new FieldWrap(fieldName, desFieldResult.getLabel());       
                        fieldWrapper.add(wmp);
                    }
                    
                }
                
            }
            
            response.setBody(fieldWrapper);
        }
        catch(Exception ex) {
            response.setError(Constants.ERROR_STRING + ex.getMessage());
        }
        
        return response;
        
    }
    
    /**
    * Description	: 	This method save configured object details under media file settings object.
    * 
    * Params		: 	String ()
    * 
    * Return		:   List( List of Wrapper)
    **/
    @AuraEnabled
    public static ResponseUtility saveConfiguredObjectDetails(String fileSettingDetails){

        ResponseUtility response = new ResponseUtility();
        
        try{
            
            if( String.isNotBlank(fileSettingDetails) ) {
                
                //for deserialize Media_Files_Object_Setting__c json
                Media_Files_Object_Setting__c mediaFileObjSetting = (Media_Files_Object_Setting__c)JSON.deserialize(fileSettingDetails, Media_Files_Object_Setting__c.class);
                
                if(mediaFileObjSetting != null) {
                    
                    //for checking record already exist or not
                    List<Media_Files_Object_Setting__c> fileObjSettings = new List<Media_Files_Object_Setting__c>();
                    
                    if( mediaFileObjSetting.Id == null )
                        fileObjSettings = [Select Id, Parent_Field_API_Name__c 
                                            From Media_Files_Object_Setting__c 
                                            Where Parent_Field_API_Name__c =: mediaFileObjSetting.Parent_Field_API_Name__c AND Object_API_Name__c =: mediaFileObjSetting.Object_API_Name__c 
                                            WITH SECURITY_ENFORCED limit 1];
                  
                    
                    if( fileObjSettings.isEmpty() && mediaFileObjSetting.Id == null ) {
                                      
                        if( mediaFileObjSetting.Object_API_Name__c != null && mediaFileObjSetting.Parent_Field_API_Name__c != null) {
                        
                            //get related object name
                            String parentObjAPIName = globalDescribe.get(mediaFileObjSetting.Object_API_Name__c).getDescribe().fields.getMap().get(mediaFileObjSetting.Parent_Field_API_Name__c).getDescribe().getReferenceTo()[0].getDescribe().getName();
                            mediaFileObjSetting.Parent_Field_Object_API_Name__c = String.isNotBlank(parentObjAPIName) ? parentObjAPIName : '';    
                        }

                        //insert not exists record
                        SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.CREATABLE, new List<Media_Files_Object_Setting__c>{mediaFileObjSetting} );
                        Insert securityDecision.getRecords();
                        
                       //set success message
                        response.setSuccessMessage( Constants.SUCCESS_MESSAGE_AFTER_MEDIA_SETTING_INSERTED );
                    }
                    else if( !fileObjSettings.isEmpty() && mediaFileObjSetting.Id == null ) {
                       
                        response.setMessage( Constants.WARNING_MESSAGE_FOR_EXISTING_MEDIA_SETTING );
                    }
                    
                    else if( mediaFileObjSetting.Id != null ) {
                        
                        if( mediaFileObjSetting.Object_API_Name__c != null && mediaFileObjSetting.Parent_Field_API_Name__c != null) {
                            
                            //get related object name
                            String parentObjAPIName = globalDescribe.get(mediaFileObjSetting.Object_API_Name__c).getDescribe().fields.getMap().get(mediaFileObjSetting.Parent_Field_API_Name__c).getDescribe().getReferenceTo()[0].getDescribe().getName();
                            mediaFileObjSetting.Parent_Field_Object_API_Name__c = String.isNotBlank(parentObjAPIName) ? parentObjAPIName : '';
                        
                        }  
                        
                        //update media file setting for configured sObject
                        SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.UPDATABLE, new List<Media_Files_Object_Setting__c>{mediaFileObjSetting} );
                        Update securityDecision.getRecords();
                        
                        response.setSuccessMessage( Constants.SUCCESS_MESSAGE_AFTER_MEDIA_SETTING_UPDATED );
                    }
                    
                }
            }
        }
        catch(Exception ex) {

            response.setError(Constants.ERROR_STRING + ex.getMessage()); 
                   
        }
        
        return response;
        
    }
    
    /**
    * Description	: 	This method edit configured object details under media file settings object.
    * 
    * Params		: 	Id
    * 
    * Return		:   ResponseUtility
    **/
    @AuraEnabled
    public static ResponseUtility editConfigObjDetails(Id recordId){
        
        ResponseUtility response = new ResponseUtility();
        
        try{
            
            if(recordId != null)
                response.setBody([Select Id, Object_API_Name__c, Parent_Field_API_Name__c, Name_Field_API_Name__c, Active__c,
                                  Source_URL_Field_API_Name__c, File_Type_Field_API_Name__c, File_Size_Field_API_Name__c 
                                  From Media_Files_Object_Setting__c Where Id =:recordId WITH SECURITY_ENFORCED limit 1]);
        }
        catch(Exception ex) {
            
            response.setError(Constants.ERROR_STRING + ex.getMessage());
            
        }
        
        return response;
        
    }
    
    //for fields combobox
    public class FieldWrap{
        
        @AuraEnabled public String value{get;set;}
        @AuraEnabled public String label{get;set;}
        
        //constructor
        public FieldWrap(String value, String label){

            this.value = value;
            this.label = label;
        }
    }
    
    //for sObject combobox
    public class SobjectWrap{
        
        @AuraEnabled public String value{get;set;}
        @AuraEnabled public String label{get;set;}
        
        //constructor
        public SobjectWrap(String value, String label){

            this.value = value;
            this.label = label;
        }
    
       
    }
    
    //for all details on media file setting
    public class MediaFileSettingWrap{
        
        @AuraEnabled public List<SobjectWrap> sobjects{get;set;}
        @AuraEnabled public List<Media_Files_Object_Setting__c> mediaFileObjectSettings{get;set;}
        
    }

 
        
    
}
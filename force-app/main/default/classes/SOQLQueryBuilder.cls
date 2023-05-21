/**
* Description	: 	This controller created to make soql queries.
* 
* Created Date  : 	06/10/2020
* 
* Created By	: 	Nikita Kumari
* 
* Revision Logs :   v_1.0 Created
**/
public class SOQLQueryBuilder {

    /**
    * Description	: 	This method create query string for selected sObject.
    * 
    * Params		: 	List, Id, String, Map
    * 
    * Return		:   ResponseUtility
    **/
    public static String createSobjectQueryString( List<Media_Files_Object_Setting__c> fileObjSettings, Id recordId, String mediaFileFilter ) {
     
        //intialize variable
        String queryString = '';
        
        if(  fileObjSettings.size() > 0 && recordId != null && String.isNotBlank( mediaFileFilter )) {
            
            queryString = 'SELECT ' + checkStringIsBlank( fileObjSettings[0].Name_Field_API_Name__c ) 
                					+ checkStringIsBlank( fileObjSettings[0].Source_URL_Field_API_Name__c ) 
                					+ checkStringIsBlank( fileObjSettings[0].File_Type_Field_API_Name__c ) 
                					+ checkStringIsBlank( fileObjSettings[0].File_Size_Field_API_Name__c ) 
                					+ ' CreatedDate FROM ' + fileObjSettings[0].Object_API_Name__c
                					+ ' WHERE ' + fileObjSettings[0].Parent_Field_API_Name__c
                					+ ' = \'' + String.escapeSingleQuotes(recordId) + '\' AND ' + fileObjSettings[0].File_Type_Field_API_Name__c 
                					+ ' IN :mediaTypeValues ORDER BY LastModifiedDate Desc';
             
        }
        
        return queryString;
    }
      
    /**
    * Description	: 	This method check text field value is blank or not.
    * 
    * Params		: 	String
    * 
    * Return		:   String
    **/
    public static String checkStringIsBlank( String fileObjSettingField ) {
     
        return String.isNotBlank( fileObjSettingField ) ? fileObjSettingField + ', ' : '';	
    }
}
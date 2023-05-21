/**
* Description	: 	This is a media file wrapper class.
* 
* Created Date  : 	06/11/2020
* 
* Created By	: 	Nikita Kumari
* 
* Revision Logs :   v_1.0 Created
**/
public class MediaFileWrapper{
    
    @AuraEnabled public Id fileId{get;set;}
    @AuraEnabled public String fileURL{get;set;}
    @AuraEnabled public String fileName{get;set;}
    @AuraEnabled public String fileSize{get;set;}
    @AuraEnabled public String fileType{get;set;}
    @AuraEnabled public Date createdDate{get;set;}
    @AuraEnabled public Boolean isAudio{get;set;}
    @AuraEnabled public Boolean isVideo{get;set;}
    @AuraEnabled public Boolean isImage{get;set;}
    
    //constructor
    public MediaFileWrapper(Id fileRecordId, String fileURL, String fileName, String fileSize, String fileType, Date createdDate, Map<String, Set<String>> mapMediaTypes){
        
        this.fileId = fileRecordId;
        this.fileURL = fileURL;
        this.fileName = fileName;
        this.fileSize = fileSize;
        this.fileType = fileType;
        this.createdDate = createdDate;
        
        //check media file type and set true accordingly
        if( mapMediaTypes.containsKey(Constants.VIDEO_STRING) && mapMediaTypes.get(Constants.VIDEO_STRING).contains(fileType) )
            this.isVideo = true;
        
        else if( mapMediaTypes.containsKey(Constants.AUDIO_STRING) && mapMediaTypes.get(Constants.AUDIO_STRING).contains(fileType) )
            this.isAudio = true;
        
        else if( mapMediaTypes.containsKey(Constants.IMAGE_STRING) && mapMediaTypes.get(Constants.IMAGE_STRING).contains(fileType) )
            this.isImage = true;
    }
}
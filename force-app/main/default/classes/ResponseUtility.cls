/**
*  Description     :   This class is handle all types of errors.
*
*  Created Date    :   05/20/2020
*
*  Version         :   V_1.0
*
*  Revision Logs   :   V_1.0 Created
* 
**/
public class ResponseUtility {

    @AuraEnabled
    public String status;
    @AuraEnabled
    public Boolean isSuccess;
    @AuraEnabled
    public String message;
    @AuraEnabled
    public Object body;
    
    public ResponseUtility() {
        status = 'Success';
        isSuccess = true;
    }
    
    public void setError(String msg) {
        status = 'Error';
        message = msg;
        isSuccess = false;
    }
    
    public void setMessage(String msg) {
        status = 'Warning';
        message = msg;
        isSuccess = false;
    }
    
    public void setBody(Object bdy) {
        body = bdy;
        status = 'Success';
        isSuccess = true;
    }
        
    public void setSuccessMessage(String msg) {
        status = 'Success';
        message = msg;
        isSuccess = true;
    }
}
/**
* Description	: 	This controller created to initialize all constants.
* 
* Created Date  : 	05/25/2020
* 
* Created By	: 	Nikita Kumari
* 
* Revision Logs :   v_1.0 Created
*
**/
public class Constants {

    public static final String MY_DOMAIN_NAME = URL.getSalesforceBaseUrl().getHost().split('.my.')[0];
    public static final String PROTOCOL_HTTPS_STRING = 'https://';
    //public static final String CONTENT_VERSION_DOWNLOAD = '--c.documentforce.com/sfc/servlet.shepherd/version/download/';
    public static final String CONTENT_VERSION_DOWNLOAD = System.Label.Content_URL_Format + '/sfc/servlet.shepherd/version/download/';
    public static final String ATTACHMENT_DOWNLOAD = System.Label.Content_URL_Format + '/servlet/servlet.FileDownload?file=';
    public static final Integer ONE_KB_SIZE = 1024;
    public static final String BYTE_STRING = 'Bytes';
    public static final String KB_STRING = 'KB';
    public static final String MB_STRING = 'MB';
    public static final String GB_STRING = 'GB';
    public static final String ALL_STRING = 'All';    
    public static final String AUDIO_STRING = 'Audio';
    public static final String VIDEO_STRING = 'Video';
    public static final String IMAGE_STRING = 'Image';
    public static final String ERROR_STRING = 'Error:: ';
    public static final String SOBJECT_NAME_NOTES_AND_ATTACHMENTS = 'Notes and Attachments';
    public static final String SUCCESS_MESSAGE_AFTER_MEDIA_SETTING_INSERTED = 'Sobject successfully configured.';
    public static final String WARNING_MESSAGE_FOR_EXISTING_MEDIA_SETTING = 'This sObject is already configured.';
    public static final String SUCCESS_MESSAGE_AFTER_MEDIA_SETTING_UPDATED = 'Sobject successfully edited.';
    public static final String CASE_OBJECT_API_NAME = 'CASE';
    public static final String EMAIL_SERVICES_FUNCTION_EMAIL_TO_CASE = 'EmailToCase';
    public static final String FILE_TYPE_ATTACHMENT = 'attachment';
    public static final String FILE_TYPE_CONTENT_DOCUMENT_LINK = 'contentdocumentlink';
    public static final String ALL_USERS = 'AllUsers';
    public static final String HISTORY = '__history';
    public static final String SHARE = '__share';
    public static final String TAG = '__tag';
    public static final String FEED = '__feed';
    
    public static final Set<String> POLYMORPIC_OBJECTS_CONST = new Set<String> {'processinstanceworkitem','attachment','caseteammember',
        'contentdocumentlink', 'duplicaterecorditem', 'emailmessage',
        'emailmessagerelation', 'entitysubscription', 'eventrelation',
        'feeditem', 'flowinterviewshare', 'todaygoalshare',
        'collaborationgrouprecord', 'contentworkspacemember', 'note',
        'outgoingemail', 'outgoingemailrelation', 'usershare',
        'vote', 'apextestqueueitem', 'announcement',
        'todaygoal', 'objectpermissions', 'userprovaccount',
        'profile', 'PromptAction', 'OauthCustomScope',
        'EnhancedLetterhead', 'AuthorizationFormText', 'AuthorizationFormDataUse',
        'AuthorizationFormConsent', 'AuthorizationForm', 'Recommendation',
        'Image', 'ExpressionFilterCriteria', 'ExpressionFilter',
        'DataUsePurpose', 'DataUseLegalBasis', 'ContactPointTypeConsent',
        'AppAnalyticsQueryRequest', 'ProductConsumptionSchedule', 'ConsumptionRate',
        'ConsumptionSchedule', 'ListEmailIndividualRecipient', 'WaveAutoInstallRequest',
        'FlowRecordRelation', 'OrgDeleteRequest', 'RecordAction',
        'ListEmailRecipientSource', 'ListEmail', 'AssetRelationship',
        'OutgoingEmailRelation', 'OutgoingEmail', 'DuplicateRecordItem',
        'DuplicateRecordSet', 'TodayGoal', 'MatchingInformation',
        'ExternalEvent', 'ExternalEventMapping', 'ConferenceNumber',
        'InstalledMobileApp', 'QuickText', 'DatacloudPurchaseUsage',
        'LeadCleanInfo', 'ContactCleanInfo', 'AccountCleanInfo',
        'DandBCompany', 'FlowInterview', 'PermissionSetLicenseAssign',
        'StreamingChannel', 'Announcement', 'CollaborationGroupRecord',
        'ContentAsset', 'MacroInstruction', 'ContentFolder',
        'Macro', 'IdeaComment', 'Idea',
        'AccountContactRole', 'SearchPromotionRule', 'Individual',
        'EmailMessageRelation', 'EmailMessage', 'AuthSession',
        'TopicAssignment', 'Topic', 'CategoryData',
        'EventRelation', 'SetupEntityAccess', 'FieldPermissions',
        'ObjectPermissions', 'PermissionSetAssignment', 'QueueSobject',
        'GroupMember', 'Group', 'ApexTestQueueItem',
        'ProcessInstanceWorkitem', 'PushTopic', 'CollaborationInvitation', 
        'CollaborationGroupMemberRequest', 'CollaborationGroupMember', 'CollaborationGroup',
        'EntitySubscription', 'Note', 'ContentFolderMember',
        'ContentDistributionView', 'ContentDistribution', 'ContentWorkspaceMember',
        'ContentDocumentSubscription', 'ContentVersionRating', 'ContentNotification',
        'ContentVersionComment', 'ContentWorkspacePermission', 'ContentWorkspaceDoc',
        'ContentWorkspace', 'ContentDocumentLink', 'ContentDocument',
        'ContentVersion', 'Holiday', 'Solution',
        'CaseSolution', 'CaseContactRole', 'CaseTeamTemplateRecord',
        'CaseTeamRole', 'CaseTeamMember', 'CaseTeamTemplateMember',
        'CaseTeamTemplate', 'CaseComment', 'OpportunityPartner',
        'AccountPartner', 'Partner', 'OpportunityCompetitor',
        'OpportunityLineItem', 'OpportunityContactRole', 'Vote',
        'ClientBrowser', 'LoginIp', 'EmailTemplate',
        'Document', 'ContractContactRole', 'OrderItem',
        'history', 'History', 'user',
        'User', '__user', '__User',
        'share', '__share', 'Share',
        '__Share', 'tag', 'Tag',
        'Feed', 'feed', 'DashboardFeed',
        'DashboardComponentFeed', 'UserPackageLicense', 'TaskFeed',
        'EventFeed', 'SiteFeed', 'TopicFeed',
        'TopicUserEvent', 'UserAppMenuCustomization', 'UserAppMenuCustomizationShare',
        'QuickTextShare', 'AuthorizationFormShare', 'AuthorizationFormConsentShare',
        'AuthorizationFormDataUseShare', 'PromptActionShare', 'EnhancedLetterheadFeed',
        'ConsumptionScheduleShare', 'ConsumptionScheduleFeed', 'DataUseLegalBasisShare',
        'DataUsePurposeShare', 'ImageShare', 'OrgDeleteRequestShare',
        'ListEmailShare', 'AssetRelationshipFeed', 'TodayGoalShare',
        'ExternalEventMappingShare', 'UserProvAccountStaging', 'UserProvAccount',
        'UserProvMockTarget', 'UserProvisioningLog', 'UserProvisioningRequestShare',
        'UserProvisioningRequest', 'UserAppInfo', 'FlowInterviewShare',
        'StreamingChannelShare', 'MacroShare', 'GoalLink',
        'Goal', 'WorkCoaching'
        };
}

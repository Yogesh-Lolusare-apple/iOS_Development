//
//  TSServerClass.m
//  EMR
//
//  Created by Tacktile Systems on 17/07/14.
//  Copyright (c) 2014 Tacktile Systems. All rights reserved.
//

#import "TSServerClass.h"
#import  "AFNetworking.h"
#import "RNDecryptor.h"
#import "RNEncryptor.h"
#import "UICKeyChainStore.h"
#import "TSCheckInAppNet.h"
#import "TSDatabaseInteraction.h"
#import "TSGetNewsCaddyServer.h"
#import "TSDBAdmissionReference.h"
#import "TSDBNotes.h"
#import "TSMedicationDB.h"
#import "TSNetDiagnosisNet.h"
#import "TSNetDeviceToken.h"
#import "TSDBAlertComments.h"
#import "TSDBTaskComments.h"
#import "TSDBTaskAssignments.h"



static TSServerClass *sharedInstance = nil;

@interface TSServerClass()
{
    NSTimer *_SyncTimer;
    NSTimer *_SharedTimer;
    NSTimer *_PullTimer;
    NSTimer *_NewsTimer;
    NSTimer *_locationBaseAccessTimer;
    BOOL isSharedThread;
    int refDataFilleForUserID;
    UIAlertView* alertTESTING;
}

@end
@implementation TSServerClass

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize isFolding,
currentPatientCell,
dischargedPatientCell,
currentPatientInfo,
isDetailsFolding1,
isDetailsFolding2,
isDetailsFolding3,
isDetailsFolding4,
isTaskFolding1,
isTaskFolding2,
currentCatgoryId,
arrayOfFavourites,
isFoldedCurrent,
isBatchedSet,
currentUserID,
isDataSyncStarded,
email,
pass,
arrayOfSharedPatients,
arrayOfSharedPatientsPullData,
lastPullData,
arrayOfSharedPatientsPushData,
reloadTable,
isToPushPin,
token,
isEmailVerified,
isDisclaimerAccepted,
isInDashboardandAppBackground,
authenticationDate,
isToPurchaseEMR,
isSIorUI,
subViewCalculationArray,
subViewAntibioticsArray,
naviControllerForSearch,
isBackPressedForPin,
isTrailPeriodCollapsed,
isToNOTDisplayRegistration,
isAllreadyPurchased,
arrayOfUndownloadedFiles,
arrayOfMedicators,
heightOfTabBarItem,
screenWidth,
currentTabIndex,
lbaisLocationBaseAccess,
tLocationManager,
lbaRadius,
lbaLatitude,
lbaLongitude,
lbaLocationInfo,isTaskButtonSelectedOrNot;

#pragma mark -
#pragma mark SingeltonObjectOfServerClass
+(id)SharedInstance
{
    static dispatch_once_t onceQueue;
    
    dispatch_once(&onceQueue, ^{
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        sharedInstance = [[self alloc] init];
        
        //  database = [TSDatabaseInteraction new];
        //  networking = [TSNetworking new];
    });
    if(!sharedInstance.lbaLocationInfo)
    {
        sharedInstance.lbaLocationInfo = [TSParaLocation new];
    }
    
    return sharedInstance;
    
}


#pragma mark -
#pragma mark Logcal Unit Time

-(long long)getCurrentEpochTime
{
    return ((long long)([[NSDate date] timeIntervalSince1970]) * 1000);
}
-(long long)getEpochTimeForTime:(NSDate*)date
{
    return ((long long)([date timeIntervalSince1970]) * 1000);
}

-(NSString*)getTimeInHours24ForDate:(NSDate*)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekdayCalendarUnit fromDate:date];
    
    NSString* str ;
    if(components.weekday == 1)
    {
        str = @"SUN";
    }else  if(components.weekday == 2)
    {
        str = @"MON";
    }else  if(components.weekday == 3)
    {
        str = @"TUE";
    }else  if(components.weekday == 4)
    {
        str = @"WED";
    }else  if(components.weekday == 5)
    {
        str = @"THU";
    }else  if(components.weekday == 6)
    {
        str = @"FRI";
    }
    else  if(components.weekday == 7)
    {
        str = @"SAT";
    }
    NSString* hour;
    if(components.hour < 10)
    {
        hour = [NSString stringWithFormat:@"0%ld",(long)components.hour];
    }else{
        hour = [NSString stringWithFormat:@"%ld",(long)components.hour];
    }
    NSString* minutes;
    if(components.minute < 10)
    {
        minutes = [NSString stringWithFormat:@"0%ld",(long)components.minute];
    }else{
        minutes = [NSString stringWithFormat:@"%ld",(long)components.minute];
    }
    return [NSString stringWithFormat:@"%@:%@ %@",hour,minutes,str];
}

-(NSString*)getAgeFromEpoch: (long long)epochtime{
    
    NSString* str=@"";
    
    NSDate* startDate = [NSDate dateWithTimeIntervalSince1970:epochtime/1000];
    NSDate* endDate = [NSDate date];
    NSDateComponents *components =[[NSCalendar currentCalendar] components: NSDayCalendarUnit | NSYearCalendarUnit|NSMonthCalendarUnit
                                                                  fromDate: startDate toDate: endDate options: 0];
    str =[NSString stringWithFormat:@"%dy %dm",(int)components.year,(int)components.month];
    return str;
}

-(NSString*)getAgeFromEpoch2: (long long)epochtime{
    
    NSString* str=@"";
    
    NSDate* startDate = [NSDate dateWithTimeIntervalSince1970:epochtime/1000];
    NSDate* endDate = [NSDate date];
    NSDateComponents *components =[[NSCalendar currentCalendar] components: NSDayCalendarUnit | NSYearCalendarUnit|NSMonthCalendarUnit
                                                                  fromDate: startDate toDate: endDate options: 0];
    str =[NSString stringWithFormat:@"%d",(int)components.year];
    return str;
}

-(NSString*)getDateOfBirthFromEpoch: (long long)epochtime
{
    
    
    NSDate* dob = [NSDate dateWithTimeIntervalSince1970:epochtime/1000];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear  fromDate:dob];
    NSString *str =[NSString stringWithFormat:@"%d/%d/%d",(int)components.day,(int)components.month,(int)components.year];
    return str;
    
}
-(NSDate*)getTimeFromEpoch: (long long)epochtime
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:epochtime/1000];
    return date;
}
-(NSString*) getTimeInString:(NSDate*)date
{
    NSString* string=@"";
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay  fromDate:date];
    
    if(components.day == 1 || components.day == 21 || components.day == 31){
        string = @"st";
    }else if (components.day == 2 || components.day == 22){
        string = @"nd";
    }else if (components.day == 3 || components.day == 23){
        string = @"rd";
    }else{
        string = @"th";
    }
    
    NSDateFormatter *prefixDateFormatter = [[NSDateFormatter alloc] init];    [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    
    //   [prefixDateFormatter setDateFormat:[NSString stringWithFormat:@"h:mma,d'%@' MMMM",string]];
    [prefixDateFormatter setDateFormat:[NSString stringWithFormat:@"h:mm a EEE, d'%@' MMMM",string]];
    return  [prefixDateFormatter stringFromDate:date];
}
-(NSString*) getTimeInStringInShortForm:(NSDate*)date
{
    NSString* string=@"";
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay  fromDate:date];
    
    if(components.day == 1 || components.day == 21 || components.day == 31){
        string = @"st";
    }else if (components.day == 2 || components.day == 22){
        string = @"nd";
    }else if (components.day == 3 || components.day == 23){
        string = @"rd";
    }else{
        string = @"th";
    }
    
    NSDateFormatter *prefixDateFormatter = [[NSDateFormatter alloc] init];    [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [prefixDateFormatter setDateFormat:[NSString stringWithFormat:@"h:mm a EE, d'%@' MMM",string]];
    
    return  [prefixDateFormatter stringFromDate:date];
}

#pragma mark -
#pragma mark Syncing Data
-(void)pullData
{
    
    if(self.token.length>0){
        TSNetworking* networking = [TSNetworking new];
        [networking TSNETGETPatientData:self.email :self.pass :lastPullData];
        lastPullData = [self getCurrentEpochTime];
        networking.netDelegate = self;
    }
    
}

-(void)SyncSharedDataPush
{

    
}

-(void)SyncSharedData :(TSPara_SharePatient*)sharedPatient
{
    TSPullSharedPatientData* netPull = [TSPullSharedPatientData new];
    netPull.netDelegate = self;
    NSMutableArray* array = [NSMutableArray new];
    sharedPatient.net_requestTime = [self getCurrentEpochTime];
    [array addObject:sharedPatient];
    [netPull TSNetSharingPULLPatientData:array :self.email :self.pass];
    
}
#pragma mark -
#pragma mark Syncing Data Delegates

-(void) TSDelegatePullSharedPatientDataRecivedData :(NSDictionary*)dictionary
{
      [self PULLEDDATA:dictionary];
}
-(void) TSDElegatePulledData :(NSDictionary*)dictionary
{
    [self PULLEDDATA:dictionary];
}

-(void)PULLEDDATA:(NSDictionary*)dictionary
{
    
    BOOL isExecuted = FALSE;
    TSDatabaseInteraction* database = [TSDatabaseInteraction new];
    NSArray* patients = [dictionary valueForKey:@"patients"];
    NSArray* secondDiagnosis = [dictionary valueForKey:@"secondaryDiagnosisList"];
    NSArray* tasks = [dictionary valueForKey:@"tasks"];
    NSArray* patientRequests = [dictionary valueForKey:@"patientRequests"];
    NSArray* alerts = [dictionary valueForKey:@"patientDetails"];
    // NSArray* patientDetails = [dictionary valueForKey:@"patientDetails"];
    NSArray* notes = [dictionary valueForKey:@"newNotes"];
    NSArray* admissionRef = [dictionary valueForKey:@"admissionsDischarges"];
    NSArray* medication = [dictionary valueForKey:@"prescriptions"];
    NSArray* doseTaken = [dictionary valueForKey:@"dosagesTaken"];
    NSArray* taskAssignments = [dictionary valueForKey:@"assignTasksRequests"];
    NSArray* taskComments = [dictionary valueForKey:@"taskComments"];
    NSArray* alertComments = [dictionary valueForKey:@"patientDetailComments"];
 /*
    "patients": 
    "secondaryDiagnosisList":
    "notes": [],
    "tasks": 
    "patientRequests":
    "assignTasksRequests":
    "patientDetails":
    "newNotes": 
    "admissionsDischarges":
    "prescriptions":
    "dosagesTaken":
    "taskComments":
    "patientDetailComments":
  */
    TSDBAdmissionReference* DBref = [TSDBAdmissionReference new];
    TSDBNotes* DBNotes = [TSDBNotes new];
    TSMedicationDB* DBMedication = [TSMedicationDB new];
    TSDBAlertComments* DBAlertComments = [TSDBAlertComments new];
    TSDBTaskComments* DBTaskComments = [TSDBTaskComments new];
    TSDBTaskAssignments* DBTaskAssignments = [TSDBTaskAssignments new];
    
    
    
    for(NSDictionary* dictL in patients)
    {
        isExecuted = TRUE;
        if([database TSBALisPatientPresent:(int)[[dictL valueForKey:@"serverPatientId"] integerValue]])
        {
            [self updatePatientToDB:dictL :0];
        }else{
            [self addPatientToDB:dictL :0];
        }
    }
    for(NSDictionary* dictL in secondDiagnosis)
    {
        isExecuted = TRUE;
        
        if([database TSBALisSDPresent:(int)[[dictL valueForKey:@"serverSecondaryDiagnosisId"] integerValue]])
        {
            [self updateSecondaryDiagnosisToDB:dictL :0];
        }else{
            [self addSecondaryDiagnosisToDB:dictL :0];
        }
        
    }
    
    
    
    for(NSDictionary* dictL in tasks)
    {
        isExecuted = TRUE;
        if([database TSBALisTaskPresent:(int)[[dictL valueForKey:@"serverTaskId"] integerValue]])
        {
            [self updateTasktoDB:dictL :0];
        }else{
            [self addTasktoDB:dictL :0];
        }
    }
    
    for(NSDictionary* dictL in alerts)
    {
        isExecuted = TRUE;
        if([database TSBALisALERTPresent:(int)[[dictL valueForKey:@"serverPatientDetailId"] integerValue]])
        {
            
            
            [self updateAlertToDB :dictL :0];
        }else{
            [self addAlertToDB:dictL :0];
        }
    }
    
    for(NSDictionary* dictL in admissionRef)
    {
        
        if([DBref TSisAdREfGivenServerIdPresend:[[dictL valueForKey:@"serverPatientAdmissionDischargeId"] longLongValue]])
        {
            [self updateAdmRefToDB:dictL :0];
        }else{
            [self addAdmRefToDB:dictL :0];
        }
    }
    for(NSDictionary* dictL in notes)
    {
        
        if([DBNotes TSisNotesServerIdPresend:[[dictL valueForKey:@"serverNoteId"] longLongValue]])
        {
            [self updateNotesToDB:dictL :0];
        }else{
            [self addNotesToDB:dictL :0];
        }
    }
    for(NSDictionary* dictL in medication)
    {
        if([DBMedication TSisDoseServerIdPresend:[[dictL valueForKey:@"serverMedPrescriptionId"] longLongValue]])
        {
            [self updateMedicationToDB:dictL :0];
        }else{
            [self addMedicationToDB:dictL :0];
        }
    }
    for(NSDictionary* dictL in doseTaken)
    {
        if([DBMedication TSisDoseTakenServerIdPresent:[[dictL valueForKey:@"serverDosageTakenId"] longLongValue]])
        {
            [self updateDoseTakenToDB:dictL :0];
        }else{
            [self addDoseTakenToDB:dictL :0];
        }
    }
    
    for(NSDictionary* dictL in taskAssignments)
    {
        
        if([DBTaskAssignments TSisTaskAssignmentPresent:[[dictL valueForKey:@"serverAssignTaskId"] longLongValue]])
        {
            [self updateTaskAssignmentsToDB:dictL ];
        }else{
            [self addTaskAssignmentsToDB:dictL ];
        }
    }
    
    
    for(NSDictionary* dictL in taskComments)
    {
        
        if([DBTaskComments TSisTaskCommentPresent:[[dictL valueForKey:@"serverTaskCommentId"] longLongValue]])
        {
            [self updateTaskCommentToDB:dictL];
        }else{
            [self addTaskCommentToDB:dictL];
        }
    }
    
    
    for(NSDictionary* dictL in alertComments)
    {
        
        if([DBAlertComments TSisAlertCommentPresent:[[dictL valueForKey:@"serverPDetailCommentId"] longLongValue]])
        {
            [self updateAlertCommentToDB:dictL];
        }else{
            [self addAlertCommentToDB:dictL];
        }
    }
    NSMutableArray* requestArray = [NSMutableArray new];
    for(NSDictionary* dict in patientRequests)
    {
        isExecuted = TRUE;
        TSPara_SharePatient *share = [TSPara_SharePatient new];
        share.net_serverPendingRequestId = (int)[[dict valueForKey:@"serverPendingRequestId"] integerValue];
        share.net_fromUserId =(int) [[dict valueForKey:@"fromUserId"] integerValue];
        share.net_toUserId = (int)[[dict valueForKey:@"toUserId"] integerValue];
        share.net_serverPatientId = (int)[[dict valueForKey:@"serverPatientId"] integerValue];
        share.net_requestStatus =(int) [[dict valueForKey:@"updatedTime"] longLongValue];
        share.net_updatedTime = [[dict valueForKey:@"requestStatus"] integerValue];
        share.net_rights = (int)[[dict valueForKey:@"rights"] integerValue];
        share.net_userFName = [dict valueForKey:@"userFName"];
        share.net_userLName = [dict valueForKey:@"userLName"];
        share.net_patientFName = [dict valueForKey:@"patientFName"];
        share.net_patientLName = [dict valueForKey:@"patientLName"];
        [requestArray addObject:share];
    }
    if(requestArray.count > 0){
        self.arrayOfSharedPatients = [NSMutableArray new];
        self.arrayOfSharedPatients = requestArray;
    }
    if(isExecuted){
        [self.reloadTable  delegateReloadTable];
    }
    
}

-(void) TSDelegateSyncPatient :(NSMutableArray*)list
{
    BOOL isExecuted = FALSE;
    for(NSDictionary* dict in list){
        isExecuted = TRUE;
        [self updatePatientToDB:dict :0];
    }
    
    [self SyncLevel2];
    
    if(isExecuted){
        
        [self.reloadTable delegateReloadTable];
        
        
    }
}
-(void) TSDelegateSyncTask :(NSMutableArray*)list
{
    BOOL isExecuted = FALSE;
    for(NSDictionary* dict in list){
        [self updateTasktoDB:dict :0];
        isExecuted = TRUE;
    }
    [self SyncLevel3CommentTask_Assigmnment];
    if(isExecuted)
    {
        [self.reloadTable  delegateReloadTable];
    }
}
-(void) TSDelegateSyncSecDiag:(NSMutableArray*)list
{
    BOOL isExecuted = FALSE;
    for(NSDictionary* dict in list){
        
        [self updateSecondaryDiagnosisToDB:dict :0];
        isExecuted = TRUE;
    }
    if(isExecuted){
        [self.reloadTable  delegateReloadTable];
    }
}
-(void) TSDelegateSyncAlert:(NSMutableArray*)list
{
    BOOL isExecuted = FALSE;
    for(NSDictionary* dict in list){
        
        [self updateAlertToDB:dict :0];
        isExecuted = TRUE;
    }
    [self SyncLevel3CommmentAlert];
    if(isExecuted){
        [self.reloadTable  delegateReloadTable];
    }
}
-(void) TSDElegateRecievedDataForSharedPAtient:(NSDictionary*)dictionary
{
    [self PULLEDDATA:dictionary];
}
-(void) TSDelegateMedicationDoseRecivedData :(NSMutableArray*)list
{
    for(NSDictionary* dict in list){
        
        [self updateMedicationToDB:dict :0];
        
    }
    
    [self SyncLevel3DoseTaken];
}
-(void) TSDelegateMedicationDoseTakenRecivedData :(NSMutableArray*)list
{
    for(NSDictionary* dict in list){
        
        [self updateDoseTakenToDB:dict :0];
        
    }
}
-(void) TSDelegateNotesRecivedData :(NSMutableArray*)list
{   for(NSDictionary* dict in list){
    
    [self updateNotesToDB:dict :0];
    
}
}
-(void) TSDelegateAdmission_ReferenceRecivedData :(NSMutableArray*)list
{
    for(NSDictionary* dict in list){
        
        [self updateAdmRefToDB:dict :0];
        
    }
    [self SyncLevel3Notes];
}
-(void) TSDelegateTaskAssignmentsRecivedData :(NSMutableArray*)list
{
    for(NSDictionary* dict in list){
        
        [self updateTaskAssignmentsToDB:dict];
        
    }
}
-(void) TSDelegateAlertCommentsRecivedData :(NSMutableArray*)list
{
    for(NSDictionary* dict in list){
        
        [self updateAlertCommentToDB:dict];
        
    }
}
-(void) TSDelegateTaskCommentsRecivedData :(NSMutableArray*)list
{
    for(NSDictionary* dict in list){
        
        [self updateTaskCommentToDB:dict];
        
    }
}

//-(void) TSDelegateTaskAssignmentsRecivedData :(NSArray*)list
//{
////    for(NSDictionary* dict in list){
////        
////        [self updateTaskAssignmentsToDB:dict];
////        
////    }
//}

#pragma mark -  OUTDATED
//Given User Share User  //PUSH
-(void) TSDelegateSharePatientResponse :(NSDictionary*)dict
{ 
    TSDatabaseInteraction *database = [TSDatabaseInteraction new];
    TSPara_SharePatient* details = [TSPara_SharePatient new];
    
    details.net_requestStatus = (int)[[dict valueForKey:@"requestStatus"] integerValue];
    
    details.net_toUserId = (int)[[dict valueForKey:@"toUserId"] integerValue];
    details.net_serverPatientId = (int)[[dict valueForKey:@"serverPatientId"] integerValue];
    details.net_toEmail = [dict valueForKey:@"toEmail"];
    
    
    int i=0;
    for(TSPara_SharePatient* share in self.arrayOfSharedPatientsPushData){
        
        
        if([share.net_toEmail isEqualToString: details.net_toEmail]){
            if(share.net_serverPatientId > 0){
                if(  share.net_serverPatientId == details.net_serverPatientId){
                    [self.arrayOfSharedPatientsPushData removeObjectAtIndex:i];
                    break;
                }
            }else{
                [self.arrayOfSharedPatientsPushData removeObjectAtIndex:i];
                break;
            }
            
        }
        i++;
    }
    [database TSBALADDSharedServerPatientId:details.net_serverPatientId];
   
}
#pragma mark -  OUTDATED


-(void)SyncLevel1
{
    TSNetworking *net = [TSNetworking new];
    TSDatabaseInteraction* database = [TSDatabaseInteraction new];
    NSMutableArray* arrayDB = [database TSBALGetPatientData];
    NSMutableArray* arrayToPass = [NSMutableArray new];
    for(TSPara_Patient *pat in arrayDB){
        if(pat.db_sync != 0){
            [arrayToPass addObject:pat];
        }
    }
    if(arrayToPass.count >0){
        [net TSNetAddPatient:arrayToPass :self.email :self.pass];
        net.netDelegate = self;
    }else{
        [self SyncLevel2];
    }
}
-(void)SyncLevel2
{
    TSNetworking *net = [TSNetworking new];
    TSDatabaseInteraction* database = [TSDatabaseInteraction new];
    NSMutableArray* arrayToPassTask = [database TSBALGetAllTask];
    
    NSMutableArray* arrayToPassDiag = [database TSBALGetALLSecDiag];
    
    //1
    if(arrayToPassTask.count > 0){
        [net TSNetAddTasks:arrayToPassTask :self.email :self.pass];
        net.netDelegate = self;
    }else{
        [self SyncLevel3CommentTask_Assigmnment];
        
    }
    //2
    if(arrayToPassDiag.count > 0){
        [net TSNetAddSecondaryDiagnosis:arrayToPassDiag :self.email :self.pass];
        net.netDelegate = self;
    }
    
    NSMutableArray* arrayToPassAlert = [database TSBALGetALLAlerts];
    
    //3
    if(arrayToPassAlert.count > 0){
        [net TSNETAddAlert:arrayToPassAlert :self.email :self.pass];
        net.netDelegate = self;
    }else
    {
        [self SyncLevel3CommmentAlert];
    }
    
    //4
    TSMedicationDB* DBMedication = [TSMedicationDB new];
    
    NSMutableArray* arrayToPassMedication = [DBMedication TSSelectDosesDataToSync];
    if(arrayToPassMedication.count > 0){
        TSNetMedicationDoses* netRef = [TSNetMedicationDoses new];
        netRef.netDelegate = self;
        [netRef TSNetAddDoses:arrayToPassMedication];
    }else
    {
        [self SyncLevel3DoseTaken];
    }
    
    //5
    TSDBAdmissionReference* DBref = [TSDBAdmissionReference new];
    NSMutableArray* arrayToPassAdmRef = [DBref TSSelectAdmissionReferenceDataToSync] ;
    if(arrayToPassAdmRef.count > 0){
        TSNetAdmission_Reference* netRef = [TSNetAdmission_Reference new];
        netRef.netDelegate = self;
        [netRef TSNetAddAdmissionReference:arrayToPassAdmRef];
        
    }else
    {
        [self SyncLevel3Notes];
    }
    
}
-(void)SyncLevel3DoseTaken
{
    
    TSMedicationDB* DBMedication = [TSMedicationDB new];
    
    NSMutableArray* arrayToPassDoseTaken = [DBMedication TSSelectDoseTakenDataToSync];
    if(arrayToPassDoseTaken.count > 0){
        TSNetMedicationDoseTaken* netDoseTaken = [TSNetMedicationDoseTaken new];
        netDoseTaken.netDelegate = self;
        [netDoseTaken TSNetAddDoseTaken:arrayToPassDoseTaken];
    }
    
}
-(void)SyncLevel3Notes
{
    TSDBNotes* DBNotes = [TSDBNotes new];
    NSMutableArray* arrayToPassNotes = [DBNotes TSSelectNotesDataToSync];
    
    
    if(arrayToPassNotes.count > 0){
        TSNetNotes* netRef = [TSNetNotes new];
        netRef.netDelegate = self;
        [netRef TSNetAddNotes:arrayToPassNotes];
    }
}
-(void)SyncLevel3CommmentAlert
{
    TSDBAlertComments* db = [TSDBAlertComments new];
    NSMutableArray* arrayToPassAlertComments=  [db TSSelectAlertCommentsToSync];
    
    if(arrayToPassAlertComments.count > 0)
    {
        TSNetAlertComments* net = [TSNetAlertComments new];
        net.netDelegate = self;
        [net TSNetAddAlertComments:arrayToPassAlertComments];
    }
    
}
-(void)SyncLevel3CommentTask_Assigmnment
{
    TSDBTaskAssignments* db1 = [TSDBTaskAssignments new];
    NSMutableArray* arrayToPassTaskAssignments=  [db1 TSSelectTAskAssignmentDataToSync];
    if(arrayToPassTaskAssignments.count > 0)
    {
      //  TSNetTaskAssignments* net = [TSNetTaskAssignments new];
       // net.netDelegate = self;
      //  [net TSNetAddTaskAssignments:arrayToPassTaskAssignments];
    }
    
    TSDBTaskComments* db2 = [TSDBTaskComments new];
    NSMutableArray* arrayToPassTaskComments=  [db2 TSSelectTaskCommentsToSync];
    if(arrayToPassTaskComments.count > 0)
    {TSNetTaskComments* net2 = [TSNetTaskComments new];
        net2.netDelegate = self;
        [net2 TSNetAddTaskComments:arrayToPassTaskComments];
        
    }
    
}

#pragma mark -
#pragma mark NEETWORKING
- (BOOL)isInternetConnected
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}
#pragma mark -
#pragma mark CORE_DATA
- (NSManagedObjectContext *) managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return _managedObjectContext;
}
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    
    
    
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"TS_EMR.sqlite"]];
    
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES
                              };
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         */
        
        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Database Issue" message:@"Please contact caddy team (in contact us), to fix this sever issue & help us to deliver the best." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        alert.tag = 404;
        [alert show];
    }
    
    return _persistentStoreCoordinator;
    
}
- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark - Colour HEX String to UIColor object
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

#pragma mark - Dictionary To Database
-(void) addPatientToDB: (NSDictionary*) dict :(int)type
{
    TSDatabaseInteraction *database = [TSDatabaseInteraction new];
    TSPara_Patient *patient = [TSPara_Patient new];
    patient.db_admited_timestamp = [[dict valueForKey:@"admittedTimestamp"] longLongValue];;
    patient.db_age = [[dict valueForKey:@"age"] longLongValue];
    patient.db_discharged_timestamp = [[dict valueForKey:@"dischargedTimestamp"] longLongValue];
    if([[dict valueForKey:@"gender"]  isEqualToString:@"m"]){
        patient.db_gender = TRUE;
    }else{
        patient.db_gender = FALSE;
    }
    
    patient.db_firstname = [dict valueForKey:@"firstName"];
    patient.db_lastname = [dict valueForKey:@"lastName"];
    patient.db_nationality = [dict valueForKey:@"nationality"];
    patient.db_primary_diagnostic = [dict valueForKey:@"primaryDiagnosis"];
    patient.db_room_id = [dict valueForKey:@"roomId"];
    patient.db_server_id  = [[dict valueForKey:@"serverPatientId"] integerValue];
    
    patient.db_status = [[dict valueForKey:@"status"] integerValue];
    patient.db_sync = 0;//[[dict valueForKey:@"syncFlag"] integerValue];
    patient.db_updated_time = [[dict valueForKey:@"updatedTime"] longLongValue];
    patient.db_user_id = self.currentUserID;
    patient.db_ward = [dict valueForKey:@"ward"];
    patient.db_healthIndexNumber = [dict valueForKey:@"healthIndexNumber"];
    //    if(type == 1){
    //        patient.db_isshared = TRUE;
    //    }else{
    //        if([database TSBALisPAtientSharedByServerID:(int)[[dict valueForKey:@"serverPatientId"] integerValue]])
    //        {
    //            patient.db_isshared = TRUE;
    //        }
    //    }
    //   patient.db_id =  [[dict valueForKey:@"devicePatientId"] integerValue];
    if(patient.db_server_id >0)
    {
        [database TSBALADDPatient:patient];
    }
    
}
-(void) updatePatientToDB: (NSDictionary*) dict :(int)type
{
    
    
    TSDatabaseInteraction *database = [TSDatabaseInteraction new];
    TSPara_Patient *patient = [TSPara_Patient new];
    patient.db_admited_timestamp = [[dict valueForKey:@"admittedTimestamp"] longLongValue];;
    patient.db_age = [[dict valueForKey:@"age"] longLongValue];
    patient.db_discharged_timestamp = [[dict valueForKey:@"dischargedTimestamp"] longLongValue];
    if([[dict valueForKey:@"gender"]  isEqualToString:@"m"]){
        patient.db_gender = TRUE;
    }else{
        patient.db_gender = FALSE;
    }
    
    
    patient.db_firstname = [dict valueForKey:@"firstName"];
    patient.db_lastname = [dict valueForKey:@"lastName"];
    patient.db_nationality = [dict valueForKey:@"nationality"];
    patient.db_primary_diagnostic = [dict valueForKey:@"primaryDiagnosis"];
    patient.db_room_id = [dict valueForKey:@"roomId"];
    patient.db_server_id  = [[dict valueForKey:@"serverPatientId"] integerValue];
    patient.db_status = [[dict valueForKey:@"status"] integerValue];
    patient.db_sync =0;// [[dict valueForKey:@"syncFlag"] integerValue];
    patient.db_updated_time = [[dict valueForKey:@"updatedTime"] longLongValue];
    patient.db_user_id = self.currentUserID;
    patient.db_ward = [dict valueForKey:@"ward"];
    patient.db_healthIndexNumber = [dict valueForKey:@"healthIndexNumber"];
    int deviceID = [database TSBAlGetDBId:(int)[[dict valueForKey:@"serverPatientId"] integerValue]];
    
    if(deviceID < 1)
    {
        deviceID =  [[dict valueForKey:@"devicePatientId"] integerValue];
    }
    patient.db_id = deviceID;
    // patient.db_id =  [[dict valueForKey:@"devicePatientId"] integerValue];
    //    if(type == 1){
    //        patient.db_isshared = TRUE;
    //    }else{
    //        patient.db_isshared = [database TSBALisPAtientShared:patient.db_id];
    //
    //        if([database TSBALisPAtientSharedByServerID:(int)[[dict valueForKey:@"serverPatientId"] integerValue]])
    //        {
    //            patient.db_isshared = TRUE;
    //        }
    //
    //    }
    if(deviceID > 0){
        
        [database TSBALUpdatePatient:patient];
        
    }
    
}

-(void) addSecondaryDiagnosisToDB: (NSDictionary*) dict :(int)type
{
    TSDatabaseInteraction *database = [TSDatabaseInteraction new];
    TSPara_Diagnosis *diag = [TSPara_Diagnosis new];
    int idd = [database TSBAlGetDBId:(int)[[dict valueForKey:@"serverPatientId"] integerValue]];
    diag.db_patient_id = idd;
    
    diag.db_id = (int) [[dict valueForKey:@"deviceSecondaryDiagnosisId"] integerValue];
    diag.db_server_id = [[dict valueForKey:@"serverSecondaryDiagnosisId"] integerValue];;
    diag.db_sync = 0;//[[dict valueForKey:@"syncFlag"] integerValue];
    diag.db_secondary_diagnostic = [dict valueForKey:@"text"] ;
    diag.db_updated_time = [[dict valueForKey:@"updatedTime"] longLongValue];
    
    if(idd > 0 && diag.db_server_id >0){
        [database TSBALADDSecondaryDiagnosis:diag];
    }
}
-(void) updateSecondaryDiagnosisToDB: (NSDictionary*) dict :(int)type
{
    TSDatabaseInteraction *database = [TSDatabaseInteraction new];
    TSPara_Diagnosis *diag = [TSPara_Diagnosis new];
    
    
    int idd = [database TSBAlGetDBId:(int)[[dict valueForKey:@"serverPatientId"] integerValue]];
    diag.db_patient_id = idd;
    
    int deviceID = [database TSBAlGetDBSecDiagId:(int)[[dict valueForKey:@"serverSecondaryDiagnosisId"] integerValue]];
    if(deviceID < 1)
    {
        deviceID =  [[dict valueForKey:@"deviceSecondaryDiagnosisId"] integerValue];
    }
    
    diag.db_server_id = [[dict valueForKey:@"serverSecondaryDiagnosisId"] integerValue];;
    diag.db_sync = 0;//[[dict valueForKey:@"syncFlag"] integerValue];
    diag.db_secondary_diagnostic = [dict valueForKey:@"text"] ;
    diag.db_updated_time = [[dict valueForKey:@"updatedTime"] longLongValue];
    diag.db_user_id = self.currentUserID;
    
    diag.db_id =  deviceID;
    
    if(idd > 0 && deviceID > 0){
        [database TSBALUpdateSecondaryDiagnosis:diag];
    }
    
}

-(void) addTasktoDB :(NSDictionary*)dict :(int)type
{
    TSDatabaseInteraction *database = [TSDatabaseInteraction new];
    TSPara_Task *task = [TSPara_Task new];
    
    int idd = [database TSBAlGetDBId:(int)[[dict valueForKey:@"serverPatientId"] integerValue]];
    task.db_patient_id =idd;
    task.db_server_id =  [[dict valueForKey:@"serverTaskId"] integerValue];
    task.db_sync = 0;//[[dict valueForKey:@"syncFlag"] integerValue];;
    task.db_create_timestamp = [[dict valueForKey:@"createdTimestamp"] longLongValue];
    task.db_due_timestamp = [[dict valueForKey:@"dueTimestamp"] longLongValue];
    task.db_status = [[dict valueForKey:@"status"] integerValue];
    task.db_updated_timestamp = [[dict valueForKey:@"updatedTime"] longLongValue];
    task.db_task_category_id = (int)[[dict valueForKey:@"taskCategoryId"] integerValue];
    task.db_id = (int)[[dict valueForKey:@"deviceTaskId"] integerValue];
    task.db_name = [[dict valueForKey:@"note"] stringByRemovingPercentEncoding];
    
    if(idd > 0 &&  task.db_server_id>0){
        [database TSBALAddTask:task];
    }
}
-(void) updateTasktoDB :(NSDictionary*)dict :(int)type
{
    TSDatabaseInteraction *database = [TSDatabaseInteraction new];
    TSPara_Task *task = [TSPara_Task new];
    int idd= [database TSBAlGetDBId:(int)[[dict valueForKey:@"serverPatientId"] integerValue]];
    task.db_patient_id = idd;
    task.db_server_id =  [[dict valueForKey:@"serverTaskId"] integerValue];
    task.db_sync = 0;//[[dict valueForKey:@"syncFlag"] integerValue];;
    task.db_create_timestamp = [[dict valueForKey:@"createdTimestamp"] longLongValue];
    task.db_due_timestamp = [[dict valueForKey:@"dueTimestamp"] longLongValue];
    task.db_status = [[dict valueForKey:@"status"] integerValue];
    task.db_updated_timestamp = [[dict valueForKey:@"updatedTime"] longLongValue];
    task.db_task_category_id = (int)[[dict valueForKey:@"taskCategoryId"] integerValue];
    int deviceID = [database TSBAlGetDBTaskId:(int)[[dict valueForKey:@"serverTaskId"] integerValue]];
    if(deviceID < 1)
    {
        deviceID =  [[dict valueForKey:@"deviceTaskId"] integerValue];
    }
    task.db_name = [[dict valueForKey:@"note"] stringByRemovingPercentEncoding];
    task.db_user_id = self.currentUserID;
    
    task.db_id = deviceID;
    if(idd > 0 && deviceID > 0){
        [database TSBALUpdateTask:task];
    }
}

-(void) addAlertToDB: (NSDictionary*) dict :(int)type
{
    
    TSDatabaseInteraction *database = [TSDatabaseInteraction new];
    TSPara_Alert *alert = [TSPara_Alert new];
    
    
    int idd = [database TSBAlGetDBId:(int)[[dict valueForKey:@"serverPatientId"] integerValue]];
    alert.db_patient_id = idd;
    
    
    alert.db_server_id = [[dict valueForKey:@"serverPatientDetailId"] integerValue];;
    
    alert.db_sync = 0;//[[dict valueForKey:@"syncFlag"] integerValue];
    alert.db_alert_name = [dict valueForKey:@"text"] ;
    alert.db_details_category =(int)[[dict valueForKey:@"categoryId"] integerValue] ;
    alert.db_updated_time = [[dict valueForKey:@"updatedTime"] longLongValue];
    alert.db_timestamp = [[dict valueForKey:@"updatedTime"] longLongValue];
    alert.db_status = (int)[[dict valueForKey:@"status"] integerValue];
    alert.db_user_id = self.currentUserID;
    int idd2 =(int)[[dict valueForKey:@"devicePatientDetailId"] integerValue];
    
    alert.db_id =  idd2;
    
    if(alert.db_patient_id > 0){
        [database TSBALADDAlert:alert];
    }
    
}
-(void) updateAlertToDB: (NSDictionary*) dict :(int)type
{
    TSDatabaseInteraction *database = [TSDatabaseInteraction new];
    TSPara_Alert *alert = [TSPara_Alert new];
    
    
    
    int idd = [database TSBAlGetDBId:(int)[[dict valueForKey:@"serverPatientId"] integerValue]];
    alert.db_patient_id = idd;
    
    long deviceID = [database TSBAlGetDBAlertId:(int)[[dict valueForKey:@"serverPatientDetailId"] integerValue]];
    if(deviceID < 1)
    {
        deviceID =  [[dict valueForKey:@"devicePatientDetailId"] integerValue];
    }
    
    alert.db_server_id = [[dict valueForKey:@"serverPatientDetailId"] integerValue];;

    alert.db_sync = 0;//[[dict valueForKey:@"syncFlag"] integerValue];
    alert.db_alert_name = [dict valueForKey:@"text"] ;
    alert.db_details_category =(int)[[dict valueForKey:@"categoryId"] integerValue] ;
    alert.db_updated_time = [[dict valueForKey:@"updatedTime"] longLongValue];
    alert.db_timestamp = [[dict valueForKey:@"updatedTime"] longLongValue];
    alert.db_status =(int)[[dict valueForKey:@"status"] integerValue];
    alert.db_user_id = self.currentUserID;
    
    alert.db_id =  (int)deviceID;
    
    if(idd > 0 && deviceID > 0){
        [database TSBALUpdateAlert:alert];
    }
    
}

//NOTES MEDICATION
-(void) addNotesToDB: (NSDictionary*) dict :(int)type
{
    
    
    
    TSDatabaseInteraction *database = [TSDatabaseInteraction new];
    TSPara_Notes *notes = [TSPara_Notes new];
    
    
    int idd = [database TSBAlGetDBId:[[dict valueForKey:@"serverPatientId"] longLongValue]];
    notes.db_patient_id = idd;
    notes.db_patient_server_id = [[dict valueForKey:@"serverPatientId"] longLongValue];
    notes.db_notes_type = 1;
    notes.db_sync = 0;//[[dict valueForKey:@"syncFlag"] integerValue];
    notes.db_text = [dict valueForKey:@"note"];
    notes.db_auther = [dict valueForKey:@"author"];
    notes.db_server_id = [[dict valueForKey:@"serverNoteId"] longLongValue];
    notes.db_created_time = [[dict valueForKey:@"createdTime"] longLongValue];;
    notes.db_updated_by = 0;//[dict valueForKey:@"lastUpdatedBy"];;
    notes.db_updated_time = [[dict valueForKey:@"updatedTime"] longLongValue];;;
    
    if(idd > 0){
        TSDBNotes* DBNotes = [TSDBNotes new];
        [DBNotes TSAddNotes:notes];
    }
    
}
-(void) updateNotesToDB: (NSDictionary*) dict :(int)type
{
    
    TSDatabaseInteraction *database = [TSDatabaseInteraction new];
    TSPara_Notes *notes = [TSPara_Notes new];
      TSDBNotes* DBNotes = [TSDBNotes new];
    
    int idd = [database TSBAlGetDBId:[[dict valueForKey:@"serverPatientId"] longLongValue]];
    notes.db_patient_id = idd;
    notes.db_patient_server_id = [[dict valueForKey:@"serverPatientId"] longLongValue];
    notes.db_notes_type = 1;
    notes.db_sync = 0;//[[dict valueForKey:@"syncFlag"] integerValue];
    notes.db_text = [dict valueForKey:@"note"];
    notes.db_auther = [dict valueForKey:@"author"];
    notes.db_server_id = [[dict valueForKey:@"serverNoteId"] longLongValue];
    notes.db_created_time = [[dict valueForKey:@"createdTime"] longLongValue];;
    notes.db_updated_by = 0;//[dict valueForKey:@"lastUpdatedBy"];;
    notes.db_updated_time = [[dict valueForKey:@"updatedTime"] longLongValue];
    //TYPE CASTING BY NANDU
    int deviceID = (int)[DBNotes TSGetNotesLocalIdFromServerID:[[dict valueForKey:@"serverNoteId"] longLongValue]];
   
    if(deviceID < 1)
    {
        deviceID =  [[dict valueForKey:@"deviceNoteId"] integerValue];
    }
    
     notes.db_id = deviceID;
    if(idd > 0 && notes.db_id > 0){
      
        [DBNotes TSUpdatedNotes:notes];
    }
    
}

-(void) addAdmRefToDB: (NSDictionary*) dict :(int)type
{
    
    
    TSDatabaseInteraction *database = [TSDatabaseInteraction new];
    TSPara_admission_reference *admRef = [TSPara_admission_reference new];
    
    int idd = [database TSBAlGetDBId:[[dict valueForKey:@"serverPatientId"] longLongValue]];
    
    admRef.db_patient_id = idd;
    admRef.db_server_id  = [[dict valueForKey:@"serverPatientAdmissionDischargeId"] longLongValue] ;
    admRef.db_admission_time = [[dict valueForKey:@"admissionTime"] longLongValue];
    admRef.db_discharged_time = [[dict valueForKey:@"dischargeTime"] longLongValue];
    //TYPE CASTING BY NANDU
    admRef.db_admitted_by_uid = (int)[[dict valueForKey:@"admittedById"] integerValue];
    admRef.db_admitted_by_uname = [dict valueForKey:@"admittedByName"];
    admRef.db_discharged_by_uid =(int) [[dict valueForKey:@"dischargeById"] integerValue];
    admRef.db_discharged_by_uname = [dict valueForKey:@"dischargeByName"];
    admRef.db_sync = 0;
    
    if(idd > 0)
    {
        TSDBAdmissionReference *DBAR = [TSDBAdmissionReference new];
        [DBAR TSAddAdmissionReference:admRef];
    }
    
    
    
}
-(void) updateAdmRefToDB: (NSDictionary*) dict :(int)type
{
    
    
    TSDatabaseInteraction *database = [TSDatabaseInteraction new];
    TSPara_admission_reference *admRef = [TSPara_admission_reference new];
            TSDBAdmissionReference *DBAR = [TSDBAdmissionReference new];
    int idd = [database TSBAlGetDBId:[[dict valueForKey:@"serverPatientId"] longLongValue]];
    admRef.db_patient_id = idd;
    
    
    admRef.db_server_id  = [[dict valueForKey:@"serverPatientAdmissionDischargeId"] longLongValue] ;
    admRef.db_admission_time = [[dict valueForKey:@"admissionTime"] longLongValue];
    admRef.db_discharged_time = [[dict valueForKey:@"dischargeTime"] longLongValue];
    //TYPE CASTING BY NANDU
    admRef.db_admitted_by_uid = (int)[[dict valueForKey:@"admittedById"] integerValue];
    admRef.db_admitted_by_uname = [dict valueForKey:@"admittedByName"];
    admRef.db_discharged_by_uid = (int)[[dict valueForKey:@"dischargeById"] integerValue];
    admRef.db_discharged_by_uname = [dict valueForKey:@"dischargeByName"];
    admRef.db_sync = 0;
    int deviceID = (int)[DBAR TSGetAdmissionReferenceLocalIdFromServerID:[[dict valueForKey:@"serverPatientAdmissionDischargeId"] longLongValue]];
    if(deviceID < 1)
    {
        deviceID =  [[dict valueForKey:@"devicePatientAdmissionDischargeId"] integerValue];
    }

    
    
    admRef.db_id = deviceID;
    
    
    if(idd > 0 && admRef.db_id > 0 &&   admRef.db_id  > 0)
    {

        [DBAR TSUpdatedAdmissionReference:admRef];
    }
    
}

-(void) addMedicationToDB: (NSDictionary*) dict :(int)type
{
    TSDatabaseInteraction *database = [TSDatabaseInteraction new];
    TSPara_Dose *dose = [TSPara_Dose new];
    
    int idd = [database TSBAlGetDBId:[[dict valueForKey:@"serverPatientId"] longLongValue]];
    dose.db_patient_id = idd;
    dose.db_server_id  = [[dict valueForKey:@"serverMedPrescriptionId"] longLongValue] ;
    dose.db_medication_name = [dict valueForKey:@"medicineName"];
    dose.db_quantity = [dict valueForKey:@"quantity"];;
    dose.db_unit = [dict valueForKey:@"unit"];;
    dose.db_route = [dict valueForKey:@"route"];;
    dose.db_frequency = [dict valueForKey:@"frequency"];;
    dose.db_indication = [dict valueForKey:@"indication"];;
    dose.db_start_date = [[dict valueForKey:@"startDate"] longLongValue];
    dose.db_end_data = [[dict valueForKey:@"endDate"] longLongValue];
    dose.db_comment = [dict valueForKey:@"comments"];;
    dose.db_sync = 0;
    //TYPE CASTING BY NANDU
    dose.db_updated_by = (int)[[dict valueForKey:@"lastUpdatedBy"] integerValue];
    dose.db_updated_time = [[dict valueForKey:@"updatedTime"] longLongValue];
    dose.db_user_id = self.currentUserID;
    dose.db_created_by = [dict valueForKey:@"author"];;
    dose.db_timeStamp = [[dict valueForKey:@"createdTime"] longLongValue];
    dose.db_active = (int)[[dict valueForKey:@"activeFlag"] integerValue];
    
    
    if(idd > 0)
    {
        TSMedicationDB *DBMED = [TSMedicationDB new];
        [DBMED TSAddDose:dose];
    }
    
}
-(void) updateMedicationToDB: (NSDictionary*) dict :(int)type
{
    TSDatabaseInteraction *database = [TSDatabaseInteraction new];
    TSPara_Dose *dose = [TSPara_Dose new];
      TSMedicationDB *DBMED = [TSMedicationDB new];
    
    int idd = [database TSBAlGetDBId:[[dict valueForKey:@"serverPatientId"] longLongValue]];
    dose.db_patient_id = idd;
    dose.db_server_id  = [[dict valueForKey:@"serverMedPrescriptionId"] longLongValue] ;
    dose.db_medication_name = [dict valueForKey:@"medicineName"];
    dose.db_quantity = [dict valueForKey:@"quantity"];;
    dose.db_unit = [dict valueForKey:@"unit"];;
    dose.db_route = [dict valueForKey:@"route"];;
    dose.db_frequency = [dict valueForKey:@"frequency"];;
    dose.db_indication = [dict valueForKey:@"indication"];;
    dose.db_start_date = [[dict valueForKey:@"startDate"] longLongValue];
    dose.db_end_data = [[dict valueForKey:@"endDate"] longLongValue];
    dose.db_comment = [dict valueForKey:@"comments"];;
    dose.db_sync = 0;
    //TYPE CASTING BY NANDU
    dose.db_updated_by = (int)[[dict valueForKey:@"lastUpdatedBy"] integerValue];
    dose.db_updated_time = [[dict valueForKey:@"updatedTime"] longLongValue];
    dose.db_user_id = self.currentUserID;
    dose.db_created_by = [dict valueForKey:@"author"];;
    dose.db_timeStamp = [[dict valueForKey:@"createdTime"] longLongValue];
    dose.db_active = (int)[[dict valueForKey:@"activeFlag"] integerValue];
    
    int deviceID = [DBMED TSGetDoseLocalDBID:[[dict valueForKey:@"serverMedPrescriptionId"] longLongValue]];
    if(deviceID < 1)
    {
        deviceID =  [[dict valueForKey:@"deviceMedPrescriptionId"] integerValue];
    }
    dose.db_id = deviceID;
     //(int)[[dict valueForKey:@"deviceMedPrescriptionId"] integerValue];
    
    if(idd > 0 &&  dose.db_id >0)
    {
      
        [DBMED TSUpdateDose:dose];
    }
}

-(void) addDoseTakenToDB: (NSDictionary*) dict :(int)type
{
    
    TSDatabaseInteraction *database = [TSDatabaseInteraction new];
    TSPara_DoseTaken *doseTaken = [TSPara_DoseTaken new];
    
    
    TSMedicationDB *DBMED = [TSMedicationDB new];
    int idd = [database TSBAlGetDBId:[[dict valueForKey:@"serverPatientId"] longLongValue]];
    doseTaken.db_patient_id = idd;
    doseTaken.db_server_id = [[dict valueForKey:@"serverDosageTakenId"] longLongValue];
    doseTaken.db_comment = [dict valueForKey:@"comments"];
    doseTaken.db_dose_given_by = [dict valueForKey:@"author"];
    doseTaken.db_dose_id_server = [[dict valueForKey:@"medPrescriptionId"] longLongValue];
    doseTaken.db_dose_id_local =  [DBMED TSGetDoseLocalDBID:doseTaken.db_dose_id_server];;
    doseTaken.db_sync = 0;
    doseTaken.db_timeStamp = [[dict valueForKey:@"updatedTime"] longLongValue];
    doseTaken.db_user_id = self.currentUserID;
    
    
    
    if(idd > 0)
    {
        
        [DBMED TSAddDoseTaken:doseTaken];
    }
    
}
-(void) updateDoseTakenToDB: (NSDictionary*) dict :(int)type
{
    TSDatabaseInteraction *database = [TSDatabaseInteraction new];
    TSPara_DoseTaken *doseTaken = [TSPara_DoseTaken new];
    TSMedicationDB *DBMED = [TSMedicationDB new];
    
    int idd = [database TSBAlGetDBId:[[dict valueForKey:@"serverPatientId"] longLongValue]];
    doseTaken.db_patient_id = idd;
    doseTaken.db_server_id = [[dict valueForKey:@"serverDosageTakenId"] longLongValue];
    doseTaken.db_comment = [dict valueForKey:@"comments"];
    doseTaken.db_dose_given_by = [dict valueForKey:@"author"];
    doseTaken.db_dose_id_server = [[dict valueForKey:@"medPrescriptionId"] longLongValue];
    doseTaken.db_dose_id_local =  [DBMED TSGetDoseLocalDBID:doseTaken.db_dose_id_server];
    doseTaken.db_sync = 0;
    doseTaken.db_timeStamp = [[dict valueForKey:@"updatedTime"] longLongValue];
    doseTaken.db_user_id = self.currentUserInfo.userID;
    //TYPE CASTING BY NANDU
    int deviceID =  (int)[DBMED TSGetDoseTakenLocalIdFromServerID:[[dict valueForKey:@"serverDosageTakenId"] longLongValue]];
    if(deviceID < 1)
    {
        deviceID =  [[dict valueForKey:@"deviceDosageTakenId"] integerValue];
    }
    doseTaken.db_id = deviceID;
    
    
    if(idd > 0 && doseTaken.db_dose_id_local >0 &&  doseTaken.db_id > 0)
    {
        [DBMED TSUpdateDoseTaken:doseTaken];
    }
    
}

//ALERT TASK COMMENTS
-(void) addAlertCommentToDB: (NSDictionary*) dict
{
    
    TSPara_Comments* para = [TSPara_Comments new];
    TSDBAlertComments* db = [TSDBAlertComments new];
    TSDatabaseInteraction* mainDB = [TSDatabaseInteraction new];
    
    para.db_id = [[dict valueForKey:@"devicePDetailCommentId"] longLongValue];
    para.db_server_id = [[dict valueForKey:@"serverPDetailCommentId"] longLongValue];
    para.db_comment_text = [dict valueForKey:@"commentText"];
    para.db_sync = 0;
    para.db_comment_by_id = [[dict valueForKey:@"userId"] longLongValue];
    para.db_comment_by_name = [NSString stringWithFormat:@"%@ %@ %@",[dict valueForKey:@"commentedByTitle"],[dict valueForKey:@"commentedByFname"],[dict valueForKey:@"commentedByLname"]];
    para.db_created_date_time = [[dict valueForKey:@"createdTime"] longLongValue];
    para.db_comment_on_id_local = [mainDB TSBAlGetAlertLocalIdFromAlertServerId:[[dict valueForKey:@"serverPatientDetailId"] longLongValue]];
    para.db_comment_on_id_server = [[dict valueForKey:@"serverPatientDetailId"] longLongValue];
    
    if(para.db_comment_on_id_local > 0 && para.db_server_id >0)
    {
        [db TSAddCommentsToAlert:para];
    }
}
-(void) updateAlertCommentToDB: (NSDictionary*) dict
{
    NSLog(@"updateAlertCommentToDB---%@",dict);
    TSPara_Comments* para = [TSPara_Comments new];
    TSDBAlertComments* db = [TSDBAlertComments new];
    TSDatabaseInteraction* mainDB = [TSDatabaseInteraction new];
    
   
    para.db_server_id = [[dict valueForKey:@"serverPDetailCommentId"] longLongValue];
    para.db_comment_text = [dict valueForKey:@"commentText"];
    para.db_sync = 0;
    para.db_comment_by_id = [[dict valueForKey:@"userId"] longLongValue];
    para.db_comment_by_name = [NSString stringWithFormat:@"%@ %@ %@",[dict valueForKey:@"commentedByTitle"],[dict valueForKey:@"commentedByFname"],[dict valueForKey:@"commentedByLname"]];
    para.db_created_date_time = [[dict valueForKey:@"createdTime"] longLongValue];
    para.db_comment_on_id_local = [mainDB TSBAlGetAlertLocalIdFromAlertServerId:[[dict valueForKey:@"serverPatientDetailId"] longLongValue]];
    para.db_comment_on_id_server = [[dict valueForKey:@"serverPatientDetailId"] longLongValue];
    
    long long deviceID = [db TSGetAlertCommentLocalIdFromServerID:[[dict valueForKey:@"serverPDetailCommentId"] longLongValue]];
    if(deviceID < 1)
    {
        deviceID =  [[dict valueForKey:@"devicePDetailCommentId"] integerValue];
    }
    para.db_id = deviceID;
  
    if(para.db_comment_on_id_local > 0 &&  para.db_id >0)
    {
        [db TSUpdateCommentsOfAlert:para];
    }
    
}

-(void) addTaskCommentToDB: (NSDictionary*) dict
{
    TSPara_Comments* para = [TSPara_Comments new];
    TSDBTaskComments* db = [TSDBTaskComments new];
    TSDatabaseInteraction* mainDB = [TSDatabaseInteraction new];
    
    
    
    para.db_id = [[dict valueForKey:@"deviceTaskCommentId"] longLongValue];
    para.db_server_id = [[dict valueForKey:@"serverTaskCommentId"] longLongValue];
    para.db_comment_text = [dict valueForKey:@"commentText"];
    para.db_sync = 0;
    para.db_comment_by_id = [[dict valueForKey:@"userId"] longLongValue];
    para.db_comment_by_name = [NSString stringWithFormat:@"%@ %@ %@",[dict valueForKey:@"commentedByTitle"],[dict valueForKey:@"commentedByFname"],[dict valueForKey:@"commentedByLname"]];
    para.db_created_date_time = [[dict valueForKey:@"createdTime"] longLongValue];
    para.db_comment_on_id_local = [mainDB TSBAlGetTaskLocalIdFromTaskServerId:[[dict valueForKey:@"serverTaskId"] longLongValue]];
    para.db_comment_on_id_server = [[dict valueForKey:@"serverTaskId"] longLongValue];
    
    if(para.db_comment_on_id_local > 0 && para.db_server_id >0)
    {
        [db TSAddCommentsToTask:para];
    }
    
}
-(void) updateTaskCommentToDB: (NSDictionary*) dict
{
    TSPara_Comments* para = [TSPara_Comments new];
    TSDBTaskComments* db = [TSDBTaskComments new];
    TSDatabaseInteraction* mainDB = [TSDatabaseInteraction new];
    
    
    
  
    para.db_server_id = [[dict valueForKey:@"serverTaskCommentId"] longLongValue];
    para.db_comment_text = [dict valueForKey:@"commentText"];
    para.db_sync = 0;
    para.db_comment_by_id = [[dict valueForKey:@"userId"] longLongValue];
    para.db_comment_by_name = [NSString stringWithFormat:@"%@ %@ %@",[dict valueForKey:@"commentedByTitle"],[dict valueForKey:@"commentedByFname"],[dict valueForKey:@"commentedByLname"]];
    para.db_created_date_time = [[dict valueForKey:@"createdTime"] longLongValue];
    para.db_comment_on_id_local = [mainDB TSBAlGetTaskLocalIdFromTaskServerId:[[dict valueForKey:@"serverTaskId"] longLongValue]];
    para.db_comment_on_id_server = [[dict valueForKey:@"serverTaskId"] longLongValue];
    
    long long deviceID =   [db TSGetTaskCommentLocalIdFromServerID:[[dict valueForKey:@"serverTaskCommentId"] longLongValue]];
    if(deviceID < 1)
    {
        deviceID =  [[dict valueForKey:@"deviceTaskCommentId"] integerValue];
    }
    para.db_id = deviceID;
    if(para.db_comment_on_id_local > 0 && para.db_server_id >0)
    {
        [db TSUpdateCommentsOfTask:para];
    }
    
}

//TASK ASSIGNMENTS
-(void) addTaskAssignmentsToDB: (NSDictionary*) dict
{
    
}
-(void) updateTaskAssignmentsToDB: (NSDictionary*) dict
{
    
}

#pragma mark - TimerToPushData
- (void)startTimer
{
    if (!_SyncTimer) {
        _SyncTimer = [NSTimer scheduledTimerWithTimeInterval:60  //600
                                                      target:self
                                                    selector:@selector(_timerFired)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}
- (void)stopTimer
{
    if ([_SyncTimer isValid]) {
        [_SyncTimer invalidate];
    }
    _SyncTimer = nil;
}
- (void)_timerFired
{
    
    if(self.currentUserInfo.userIsEmailVerified){
        if(self.isInternetConnected)
        {
            [self SyncLevel1];
        }
    }
}

/*
 #pragma mark - TimerToPushSharedData
 - (void)startTimerShared
 {
 if (!_SharedTimer) {
 _SharedTimer = [NSTimer scheduledTimerWithTimeInterval:30
 target:self
 selector:@selector(_timerFiredShared)
 userInfo:nil
 repeats:YES];
 }
 }
 - (void)stopTimerShared
 {
 if ([_SharedTimer isValid]) {
 [_SharedTimer invalidate];
 }
 _SharedTimer = nil;
 }
 - (void)_timerFiredShared
 {
 if(self.isEmailVerified){
 if(self.isInternetConnected)
 {
 [self SyncSharedDataPush];
 
 }
 }
 }
 */

#pragma mark - TimerToPushSharedData
- (void)startTimerPull
{
    if (!_PullTimer) {
        _PullTimer = [NSTimer scheduledTimerWithTimeInterval:95
                                                      target:self
                                                    selector:@selector(_timerFiredPull)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}
- (void)stopTimerPull
{
    if ([_PullTimer isValid]) {
        [_PullTimer invalidate];
    }
    _PullTimer = nil;
}
- (void)_timerFiredPull
{
    if(self.isEmailVerified){
        if(self.isInternetConnected)
        {
            [self pullData];
        }
    }
}


#pragma mark - NEWS SYNCING
- (void)startTimerNEWS
{
    if (!_NewsTimer) {
        _NewsTimer = [NSTimer scheduledTimerWithTimeInterval:180
                                                      target:self
                                                    selector:@selector(_timerFiredNEWS)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void)stopTimerNEWS
{
    if ([_NewsTimer isValid]) {
        [_NewsTimer invalidate];
    }
    _NewsTimer = nil;
}
-(void)_timerFiredNEWS
{
    // [self syncNews];
}

-(void)syncNews
{
    
    TSGetNewsCaddyServer* news = [TSGetNewsCaddyServer new];
    [news TSGetUndownloadedImages];
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString* lastNewsSyncTime =   [standardUserDefaults objectForKey:@"lastNewsSyncTime"];
    
    long long lastNewsTime  =  [lastNewsSyncTime longLongValue];
    if(lastNewsTime >0){
        NSDate* startDate = [self getTimeFromEpoch:lastNewsTime];
        NSDate* endDate = [NSDate date];
        NSDateComponents *components =[[NSCalendar currentCalendar] components: NSHourCalendarUnit|NSMinuteCalendarUnit
                                                                      fromDate: startDate toDate: endDate options: 0];
        
        if(components.hour > 5 )
        {
            TSGetNewsCaddyServer* news = [TSGetNewsCaddyServer new];
            [news TSGetNews];
        }
    }else{
        TSGetNewsCaddyServer* news = [TSGetNewsCaddyServer new];
        [news TSGetNews];
    }
    
    
}

#pragma mark - START_SYNCING_DATA
-(void)startSyncingData
{
    if(self.token.length > 0){
        isDataSyncStarded = TRUE;
        [self pullData];
    }
    [self stopTimer];
    [self stopTimerPull];
    // [self stopTimerLocationBaseAccess];
    
    
    [self startTimer];
    [self startTimerPull];
    // [self startTimerLocationBaseAccess];
}



#pragma mark - TRIL OR PURCHASE
//REAd ONLY self->_isPatientsDoNotShowMessageAgain = TRUE;
-(void)authenticateApp
{
    
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay|NSCalendarUnitHour  fromDate:[NSDate date]];
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    
    
    //  if(self.authenticationDate != components.hour){
    
    self.authenticationDate = (int)components.day;
    
    
    // Print all keys and values for the service.
    
    
    long long TrailDate  =  [[self decryptString:[UICKeyChainStore stringForKey:@"EMRTOOLS"]] longLongValue];
    
    if(TrailDate ==  0)
    {
        
        NSString* currentTime =[NSString stringWithFormat:@"%lld",[self getEpochTimeForTime:[NSDate date]]];
        //   NSLog(@"PurchasedClinicalT0DoList");
        
        [store setString:[self encryptString:currentTime] forKey:@"EMRTOOLS"];
        [store synchronize];
        
    }
    
    //    else if (TrailDate > 0){
    //        NSDate* startDate = [self getTimeFromEpoch:TrailDate];
    //        NSDate* endDate = [NSDate date];
    //        NSDateComponents *components =[[NSCalendar currentCalendar] components: NSDayCalendarUnit | NSYearCalendarUnit|NSMonthCalendarUnit|NSMinuteCalendarUnit
    //                                                                      fromDate: startDate toDate: endDate options: 0];
    //
    //        if(components.month >= 3 )
    //        {
    //            self.isToPurchaseEMR = TRUE;
    //        }
    //
    //
    //        TSCheckInAppNet* net = [TSCheckInAppNet new];
    //        net.netCheckDelegate = self;
    //        [net TSNetISTrialPeriodOnOrPurchased:@""];
    //
    //        //MAke sure payment status is i=updated to server
    //        TSDatabaseInteraction *db = [TSDatabaseInteraction new];
    //        TSPara_ValidatePayment* para = [db PayGetPaymentData];
    //        if(para!=nil)
    //        {
    //            if(!para.server_validate)
    //            {
    //                TSUpdatePurchaseNet *payment = [TSUpdatePurchaseNet new];
    //                payment.netUpdateDelegate = self;
    //                [payment TSNetUpdatePaymentStatus:para.receipt];
    //            }
    //        }
    //
    //
    //    }
    //
    //
    //
    //
    // //     }//Once in a day
    //
    //    if( [UICKeyChainStore stringForKey:@"EMReg"].length > 0){
    //        self.isToNOTDisplayRegistration = TRUE;
    //    }
    
}

#pragma mark - WEB Test TRIL OR PURCHASE
/*
 Developed Date: Phase 1,Oct 13, 2014
 Developed By: Yogesh, Tacktile System
 Purpose:PAYMENT & Trial PEriod.
 Comment:
 */

-(void) TSDelegateCheckInApp :(int)status :(NSString*)Message
{
    
    if(status == 200){ //TRIAL PERIOD
        self.isToPurchaseEMR = FALSE;
    }else if(status == 400){ //TRAIL PERIOd COLLAPSED
        self.isToPurchaseEMR = TRUE;
    }
}
-(void) TSDelegateCheckInAppError :(NSError*)error
{
    
}

-(void) TSDelegatePaymentStatusUpdatedToServer :(int)status :(NSString*)Message
{
    
    
    if(status == 200){
        TSDatabaseInteraction *db = [TSDatabaseInteraction new];
        TSPara_ValidatePayment* para = [db PayGetPaymentData];
        if(para!=nil)
        {
            para.server_store = TRUE;
            para.server_validate = TRUE;
            [db PayUpdatePaymentData:para];
        }
    }else if(status == 400){
        TSDatabaseInteraction *db = [TSDatabaseInteraction new];
        TSPara_ValidatePayment* para = [db PayGetPaymentData];
        if(para!=nil)
        {
            para.server_store = TRUE;
            para.server_validate = FALSE;
            [db PayUpdatePaymentData:para];
        }
        
    }
}
-(void) TSDelegatePaymentStatusUpdationToServerError :(NSError*)error
{
    
}


#pragma mark - ENCRYPT+DECRYPT DATA
-(NSString*)encryptString :(NSString*)string
{
    if(string == nil){
        return @"";
    }
    NSError *error;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:@"emr"                             error:&error];
    
    
    
    if ([data respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        return [encryptedData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    } else {
        return  [encryptedData base64Encoding];                // pre iOS7
    }
    
}
-(NSString*)decryptString  :(NSString*)encryptedString
{
    if(encryptedString == nil){
        return @"";
    }
    NSData *data;
    NSError *error;
    if ([NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)]) {
        data = [[NSData alloc] initWithBase64EncodedString:encryptedString options:kNilOptions];  // iOS 7+
    } else {
        data = [[NSData alloc] initWithBase64Encoding:encryptedString];                  // pre iOS7
    }
    
    NSData *decryptedData = [RNDecryptor decryptData:data
                                        withPassword:@"emr"
                                               error:&error];
    
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

#pragma mark - REGESTRATION ONLY ONCE ALLOWED
-(void)setRegistrationStatus
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    [store setString:@"YES" forKey:@"EMReg"];
    [store synchronize];
}

#pragma mark - FORMAT STRING XXXX-XXXX-XXXX-XXXX
-(NSString*)processHealthIndexString :(NSString*)yourString
{
    if(yourString == nil){
        return @"";
    }
    int stringLength = (int)[yourString length];
    // the string you want to process
    int len = 4;  // the length
    NSMutableString *str = [NSMutableString string];
    int i = 0;
    for (; i < stringLength; i+=len) {
        NSRange range = NSMakeRange(i, len);
        [str appendString:[yourString substringWithRange:range]];
        if(i!=stringLength -4){
            [str appendString:@"-"];
        }
    }
    if (i < [str length]-1) {  // add remain part
        [str appendString:[yourString substringFromIndex:i]];
    }
    // str now is what your want
    
    return str;
}

#pragma mark - RESET  DATA
-(void)resetUserData;
{ self.arrayOfSharedPatientsPullData = [NSMutableArray new];
    self.arrayOfSharedPatientsPushData = [NSMutableArray new];
    self.arrayOfFavourites = [NSMutableArray new];
    self.arrayOfSharedPatients = [NSMutableArray new];
    self.email = @"";
    self.pass = @"";
    self.token = @"";
    self.isToPushPin = FALSE;
    self.isEmailVerified = FALSE;
    self.lastPullData = 0;
    self.currentUserInfo = nil;
    self.isDataSyncStarded = FALSE;
    isDataSyncStarded = FALSE;
    [self stopTimer];
    [self stopTimerPull];
    [self stopTimerLocationBaseAccess];
    refDataFilleForUserID = 0;
    
    
}

#pragma mark - GetUniqueDeviceIdentifierAsString
-(NSString *)getUniqueDeviceIdentifierAsString
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    // NSString *appName=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    NSString *strApplicationUUID = [store stringForKey:@"uuidd"];;
    if (strApplicationUUID == nil)
    {
        strApplicationUUID  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [store setString:strApplicationUUID forKey:@"uuidd"];
        [store synchronize];
    }
    
    return    strApplicationUUID; //@"ABC794DF-E15B-4867-B204-42277480BF8E";//
}

#pragma mark - RESET  KEY CHAIN
-(void)resetKeyChain
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    
    [store setString:@"" forKey:@"EMRTOOLS"];
    [store setString:@"" forKey:@"EMReg"];
    
    [store synchronize];
    
}

#pragma mark - ResendEmailVerification
-(void)ResendEmailVerification
{
    TSNetworking* net = [TSNetworking new];
    net.netDelegate = self;
    [net TSNetResendVErificationCode];
}

-(void)TSDelegateResendEmailVerification:(int)status
{
    if(status == 200){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Email Verification." message:@"Verification mail sent. Please verify your email to allow data sync." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Email Verification." message:@"Unable to resend mail." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
#pragma mark - LOGOUT
-(void)logoutFunctionality{
    [self SyncLevel1];
    
    
    TSNetDeviceToken* removeDeviceTokenForUser = [TSNetDeviceToken new];
    [removeDeviceTokenForUser TSNetDeleteDeviceTokenForCurrentUser];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //In another function
        TSDatabaseInteraction* database = [TSDatabaseInteraction new];
        [database TScleanCompleteData];
        [self resetUserData];
        //[self authenticateApp];
        [self.reloadSetting delegateReloadSettings];
    });
    
}

#pragma mark - DICT to JSON
- (NSString*) convertObjectToJson:(NSObject*) object
{
    NSError *writeError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return result;
}

-(NSDictionary*)readNews
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *plistFilePath = [documentsPath stringByAppendingPathComponent:@"News.plist"]; // Correct path to Documents Dir in the App Sand box
    // read property list into memory as an NSData  object
    if([[NSFileManager defaultManager] fileExistsAtPath:plistFilePath]){
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistFilePath];
        
        
        NSString *strerrorDesc = nil;
        NSPropertyListFormat plistFormat;
        // convert static property liost into dictionary object
        NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&plistFormat errorDescription:&strerrorDesc];
        
        return  temp;
    }else{
        return nil;
    }
}

//Publishing Admission Reference data from patient data
-(BOOL)fillAdmissionReferenceData
{
    BOOL isExecuted = FALSE;
    
    if(self.currentUserID != refDataFilleForUserID){
        refDataFilleForUserID = self.currentUserID;
        
        TSDatabaseInteraction* completeDB = [TSDatabaseInteraction new];
        NSMutableArray* array = [completeDB TSBALGetPatientData];
        
        TSDBAdmissionReference* refDB = [TSDBAdmissionReference new];
        for(TSPara_Patient* patient in array)
        {
            if(![refDB TSisSessionForGivenPatientIDPresent:patient.db_id]){
                //**********************  PATIENT REFERENCE
                TSPara_admission_reference* para = [TSPara_admission_reference new];
                para.db_patient_id = patient.db_id;
                para.db_admitted_by_uname = [NSString stringWithFormat:@"%@ %@ %@ (%@)",self.currentUserInfo.userTitle,self.currentUserInfo.userFName,self.currentUserInfo.userLName,self.currentUserInfo.userPosition];
                para.db_admitted_by_uid = self.currentUserID;
                para.db_admission_time = [self getCurrentEpochTime];
                para.db_sync = 1;
                para.db_patient_server_id  = patient.db_server_id;
                
                if(patient.db_status == 2){
                    para.db_discharged_by_uid = self.currentUserID;
                    para.db_discharged_by_uname = [NSString stringWithFormat:@"%@ %@ %@ (%@)",self.currentUserInfo.userTitle,self.currentUserInfo.userFName,self.currentUserInfo.userLName,self.currentUserInfo.userPosition];
                    para.db_discharged_time = [self getCurrentEpochTime];
                }
                
                [refDB TSAddAdmissionReference:para];
                
                //********************** PATIENT REFERENCE
                isExecuted = TRUE;
                
            }
        }
    }
    
    return isExecuted;
}


#pragma mark - HANDLING DIAGNOSIS PAYMENT

-(void)tPaymentSaveDiagnosisReceiptToServer :(NSString*)receipt
{
    TSNetDiagnosisNet* net = [TSNetDiagnosisNet new];
    net.netDelegate = self;
    [net TSNetUpdatePaymentStatusForDiagnosis:receipt];
}
-(void) TSDelegateDiagnosisReceiptSendingFailure :(NSString*)receipt
{
    //Saving state to UD
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:receipt forKey:@"PAYMENT_DIAGNOSIS" ];
    
}


#pragma mark - Location Base Access

-(int)locationiSDataAccessable :(float)withRadius :(NSString*)latitude :(NSString*)longitude
{
    if([self LocationiSPermitedByOS])
    {
        if(  [self locationSetTrackerOn :withRadius : latitude:longitude])
        {
            [self locationUnlockUser];
        }else
        {
            [self locationLockUser];
        }
        [self locationSetTrackerOff];
        return 2;
    }else{
        return 1;
    }
}
/*
 Purpose: To test whether user have allowed to get his location
 */
-(BOOL)LocationiSPermitedByOS
{
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        
        return TRUE;
    }
    else
    {
        [self  locationMessage];
        return FALSE;
    }
    return FALSE;
}


/*
 Purpose: To start location tracker & let delegate get called when user MOVES OUT OG GIVEN RADOIUS FROM GIVEN LATITUDE & LOGITUDE
 
 */
-(BOOL)locationSetTrackerOn :(float)withRadius :(NSString*)latitude :(NSString*)longitude
{
    [self.tLocationManager startUpdatingLocation];
    CLLocation *tDestination = [self.tLocationManager location];
    // NSLog(@"CurrentLocationCoordinate --- %f--%f",tDestination.coordinate.latitude,tDestination.coordinate.longitude);
    CLLocation *tSource = [[CLLocation alloc]initWithLatitude:[latitude doubleValue]  longitude:[longitude doubleValue]];
    //  NSLog(@"SendLocationCoordinate --- %f--%f",tSource.coordinate.latitude,tSource.coordinate.longitude);
    
    CLLocationDistance distance = [tDestination distanceFromLocation:tSource];
    
    if(distance > withRadius)
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
    
}

/*
 
 Purpose: Stop location tracker
 */
-(void)locationSetTrackerOff
{
    [self.tLocationManager stopUpdatingLocation];
}

//When Usere Moves out of given radius
-(void)locationLockUser
{
    self.locationisAllowUserToLogin = FALSE;
    [self resetUserData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MoveToDashboard" object:self];
    
    if(!alertTESTING)
    {
        alertTESTING = [[UIAlertView alloc]initWithTitle:@"LocationBaseAccess" message:@"User is out of radius." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertTESTING show];
    }
}

//When User Moves IN of given radius
-(void)locationUnlockUser
{
    
    self.locationisAllowUserToLogin = TRUE;
}




-(void)getCurrentLocation
{
    self.tLocationManager = [[CLLocationManager alloc] init];
    
    if ([self.tLocationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.tLocationManager requestAlwaysAuthorization];
    }
    
    self.tLocationManager.delegate = self;
    //self.tLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.tLocationManager startUpdatingLocation];
}

#pragma mark - LOCATION BASE ACCESS TIMER
- (void)startTimerLocationBaseAccess
{
    //    if (!_locationBaseAccessTimer) {
    //        _locationBaseAccessTimer = [NSTimer scheduledTimerWithTimeInterval:60
    //                                                                    target:self
    //                                                                  selector:@selector(timerFiredLocationBaseAccess)
    //                                                                  userInfo:nil
    //                                                                   repeats:YES];
    //    }
}
- (void)stopTimerLocationBaseAccess
{
    //    if ([_locationBaseAccessTimer isValid]) {
    //        [_locationBaseAccessTimer invalidate];
    //    }
    //    _locationBaseAccessTimer = nil;
}
-(void)timerFiredLocationBaseAccess
{
    
    //    if(self.lbaisLocationBaseAccess)
    //    {
    //
    //        if([self locationiSDataAccessable:self.lbaRadius :self.lbaLatitude :self.lbaLongitude] == 1)
    //        {
    //            [self locationMessage];
    //        }
    //    }
}


-(void)locationMessage
{
    if(IS_DEVICE_RUNNING_IOS_8_AND_ABOVE())
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Settings"
                                                        message:@"Please enable location services for caddy app."
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Settings", nil];
        alert.tag = 1001;
        [alert show];
    }else{
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 120)];
        UIImage *wonImage = [UIImage imageNamed:@"iosSetting.png"];
        imageView.contentMode=UIViewContentModeCenter;
        [imageView setImage:wonImage];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Settings"
                                                            message:@"Please enable location services for caddy app in settings of your device."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles: nil];
        //check if os version is 7 or above
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            [alertView setValue:imageView forKey:@"accessoryView"];
        }else{
            [alertView addSubview:imageView];
        }
        [alertView show];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    alertTESTING = nil;
    if(alertView.tag == 1001)
    {
        if(buttonIndex == 1)
        {
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: UIApplicationOpenSettingsURLString]];
        }
    }
}



#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{

    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{

    CLLocation *currentLocation = newLocation;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    if (currentLocation != nil) {
        self.lbaLocationInfo.lLongitude = [NSString stringWithFormat:@"%.12f", currentLocation.coordinate.longitude];
        self.lbaLocationInfo.lLatitude = [NSString stringWithFormat:@"%.12f", currentLocation.coordinate.latitude];

    }
    
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks lastObject];
            self.lbaLocationInfo.lAddress = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                             placemark.subThoroughfare, placemark.thoroughfare,
                                             placemark.postalCode, placemark.locality,
                                             placemark.administrativeArea,
                                             placemark.country];
  
        } else {
            NSLog(@"%@", error.debugDescription);
        }
        
        [self.tLocationManager stopUpdatingLocation];
        
    } ];
}
#pragma mark - PREVENT from iCloud Backup
//http://stackoverflow.com/questions/22134910/2-23-apps-must-follow-the-ios-data-storage-guidelines-or-they-will-be-rejected
- (BOOL)taddSkipiCloudBackupAttributeToItemAtURL:(NSURL *)URL
{
    // assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    BOOL success = FALSE;
    if([[NSFileManager defaultManager] fileExistsAtPath: [URL path]])
    {
        NSError *error = nil;
        success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                 forKey: NSURLIsExcludedFromBackupKey error: &error];
        //    if(!success){
        //     //   NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        //    }
    }
    return success;
}

#pragma mark - GET BADGE VA:UE of TAB
-(int)getBadgeValueOfTab
{
    int returnValue = 0;
    NSMutableArray* alltasks = [NSMutableArray new];
    TSDatabaseInteraction* db = [TSDatabaseInteraction new];
    alltasks = [db TSBALGetPatientTask:self.currentPatientInfo.db_id];
    for(TSPara_Task* taskVar in alltasks){
        if(taskVar.db_status == 1){
            returnValue++;
        }else if(taskVar.db_status == 2){
            returnValue++;
            
        }
    }
    
    return returnValue;
    
}

-(void) TSDelegateTaskAssignmentsFailed: (NSError*)error{
 
}

@end

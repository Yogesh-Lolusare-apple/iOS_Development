//
//  TSServerClass.h
//  EMR
//
//  Created by Tacktile Systems on 17/07/14.
//  Copyright (c) 2014 Tacktile Systems. All rights reserved.
//
#import "TSParaLocation.h"
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "TSDischargedPatientCell.h"
#import "TSCurrentPatientCell.h"
#import "TSPara_Patient.h"
#import "TSNetworking.h"
#import "NSString+URLEncoding.h"
#import "TSCurrentUserInfo.h"

#import "TSDBAdmissionReference.h"

#import "TSNetAdmission_Reference.h"
#import "TSNetNotes.h"
#import "TSNetMedicationDoses.h"
#import "TSNetMedicationDoseTaken.h"
#import "TSNetDiagnosisNet.h"
#import "TSNetTaskComments.h"
#import "TSNetTaskAssignments.h"
#import "TSNetAlertComments.h"
#import "TSPullSharedPatientData.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#define HEIGHTROW 44.0
#define HEIGHTHEADER 44.0
#define HEIGHTFOOTER 0.5



#define TSFCellSize 15
#define TSFCellFamily @"HelveticaNeue-Bold"
#define TSFCellFamily2 @"Verdana"  //With out Time
#define TSFCellColor 0.5
#define TSFCell_X_Co_ordinate 65
#define TSFCell_Y_Co_ordinate 0
#define TSFCell_Y_Co_ordinate2 10 //With out Time
#define TSFCell_Width 280
#define TSFCell_Height 23

#define TSFCellTimeSize 13
#define TSFCellTimeFamily @"HelveticaNeue-Light"
//STHeitiTC-Light
#define TSFCellTimeColor 0.5
#define TSFCellTime_X_Co_ordinate 65
#define TSFCellTime_Y_Co_ordinate 20
#define TSFCellTime_Width 260
#define TSFCellTime_Height 20

#define TSFViewHeaderSize 0.5
#define TSFViewHeaderFamily 0.5
#define TSFViewHeaderColor 0.5
#define TSFViewHeader_X_Co_ordinate 0.5
#define TSFViewHeader_Y_Co_ordinate 0.5
#define TSFViewHeader_Width 0.5
#define TSFViewHeader_Height 0.5

#define TSFSectionHeaderSize 15
#define TSFSectionHeaderFamily @"Futura"   //Futura-CondensedExtraBold
#define TSFSectionHeaderColor [UIColor colorWithRed:0.106 green:0.376 blue:0.745 alpha:1]
//[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]

#define TSFSectionHeader_X_Co_ordinate 15
#define TSFSectionHeader_Y_Co_ordinate 4
#define TSFSectionHeader_Width sectionHeaderView.frame.size.width
#define TSFSectionHeader_Height 40

#define TSImage_X_Co_ordinator 89
#define TSImage_Y_Co_ordinator 40
#define TSImage_WIDTH 146
#define TSImage_HEIGHT 137




#define IS_DEVICE_RUNNING_IOS_8_AND_ABOVE() ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)
#define iPhoneVersion ([[UIScreen mainScreen] bounds].size.height == 568 ? 5 : ([[UIScreen mainScreen] bounds].size.height == 480 ? 4 : ([[UIScreen mainScreen] bounds].size.height == 667 ? 6 : ([[UIScreen mainScreen] bounds].size.height == 736 ? 61 : (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 10 :61)))))
//TSServerClass *obj = [TSServerClass sharedInstance];


@protocol TSReloadTable
@required
-(void)delegateReloadTable;


@end

@protocol TSReloadSettingDAta
@required
-(void)delegateReloadSettings;


@end

@class TSNetworking,TSDatabaseInteraction;
@interface TSServerClass : NSObject<TSNetProtocol,TSProtoAdmission_Reference,TSProtoMedicationDose,TSProtoMedicationDoseTaken,TSProtoNotes,TSProtoUpdatePaymentStatusForDiagnosis,TSProtoAlertComments,TSProtoTaskComments,TSProtoTaskAssignments,TSProtoPullSharedPatientData,UIAlertViewDelegate,CLLocationManagerDelegate,MKMapViewDelegate>

+(id)SharedInstance;

//LOCATION BASE ACCESS

@property int lbaisLocationBaseAccess;
@property (nonatomic, retain) CLLocationManager *tLocationManager;
@property float lbaRadius;
@property (nonatomic,retain) NSString* lbaLatitude;
@property (nonatomic,retain) NSString* lbaLongitude;
@property (nonatomic,retain) TSParaLocation *lbaLocationInfo;
@property bool locationisAllowUserToLogin;

@property BOOL isTaskButtonSelectedOrNot;
//Patient Dashboard //Folding Discharded patient
//DETAILS TABLE HEADER FOLDING and UNFOLDING STATUS

@property bool isFolding;
@property bool isFoldedCurrent;
@property bool isDetailsFolding1;
@property bool isDetailsFolding2;
@property bool isDetailsFolding3;
@property bool isDetailsFolding4;
@property bool isTaskFolding1;
@property bool isTaskFolding2;
//DETAILS TABLE HEADER FOLDING and UNFOLDING STATUS


@property int currentCatgoryId;


@property bool isBatchedSet;         //TASK TAB IS BATCH VALUE SET
@property bool isToPushPin;          //DISPLAY PIN VIEW
@property bool isEmailVerified;      //DATA SYNC IF EMAIL VERIFIED
@property bool isDisclaimerAccepted; //DISPLAY DISCLAIMER & NOTICE VIEW ONLY ONCE
@property bool isDataSyncStarded;    //WAIT FOR TOKEN
@property bool isInDashboardandAppBackground; //PUSHING PIN VIEW IN PATIENTS MODULE
@property bool isBackPressedForPin; //PUSHING PIN VIEW IN PATIENTS MODULE


@property bool isAllreadyPurchased; //Allready Purchased

@property bool isSIorUI; //SETTINGS

@property long long lastPullData;  //LAST PULL TIME
@property (nonatomic,retain) NSMutableArray* arrayOfFavourites; //ADD NEW TASK
@property (nonatomic,retain) NSMutableArray* arrayOfSharedPatients; //PIPELINE
@property (nonatomic,retain) NSMutableArray* arrayOfSharedPatientsPullData; //PIPELINE
@property (nonatomic,retain) NSMutableArray* arrayOfSharedPatientsPushData; //PIPELINE
@property (nonatomic,retain) NSArray* subViewCalculationArray; //ARRAY TO PASS TO DASHBOARD SEARCH
@property (nonatomic,retain) NSArray* subViewAntibioticsArray; //ARRAY TO PASS TO DASHBOARD SEARCH
@property (nonatomic,retain) TSCurrentPatientCell *currentPatientCell;  //DEPRICATED
@property (nonatomic,retain) TSDischargedPatientCell *dischargedPatientCell; //DEPRICATED
@property (nonatomic,retain) TSPara_Patient *currentPatientInfo; //CURRENT PATIENT CLICKED AT PATIENTS LIST INFO

//CURRENT USER DATA
@property int currentUserID;
@property (nonatomic,retain) NSString *email; //CURRENT USER EMAIL
@property (nonatomic,retain) NSString *pass;  //CURRENT USER PASS
@property (nonatomic,retain) NSString *token; //CURRENT TOKEN
@property (nonatomic,retain) TSCurrentUserInfo *currentUserInfo;


@property (nonatomic,retain) UINavigationController *naviControllerForSearch;
@property(nonatomic,weak) id<TSReloadTable> reloadTable; //DELAGATE TO RELOAD ONCE UPDATED DATA IS PULLED
@property(nonatomic,weak) id<TSReloadSettingDAta> reloadSetting; //DELAGATE TO RELOAD setting data

//TRAIL AND PURCHASE
@property int authenticationDate;
@property bool isToPurchaseEMR;
@property bool isTrailPeriodCollapsed;
//ONE TIME REGISTRATION
@property bool isToNOTDisplayRegistration;

@property int kTableWidth; //NEws Section
@property (nonatomic,retain) NSMutableArray* arrayOfUndownloadedFiles; //NotDownloaded Files

@property (nonatomic,retain) NSMutableArray* arrayOfMedicators; //Medicators 
//Core Data
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator ;
//Core Data

@property float heightOfTabBarItem; //Height of tab items
@property float screenWidth; //Height of tab items
@property  int currentTabIndex; //Getting Tab index 





//***********************************************************************************

//Logical Unit FOR TIME
-(long long)getCurrentEpochTime;
-(long long)getEpochTimeForTime:(NSDate*)date;
-(NSString*)getTimeInHours24ForDate:(NSDate*)date;
-(NSDate*)getTimeFromEpoch: (long long)epochtime;
-(NSString*)getAgeFromEpoch: (long long)epochtime;
-(NSString*)getAgeFromEpoch2: (long long)epochtime;
-(NSString*)getDateOfBirthFromEpoch: (long long)epochtime;
-(NSString*) getTimeInString:(NSDate*)components;
-(NSString*) getTimeInStringInShortForm:(NSDate*)date;
//Logical Unit FOR TIME

//Internet
- (BOOL)isInternetConnected ;
//Internet



//Sync
-(void)pullData;
-(void)SyncSharedData :(TSPara_SharePatient*)sharedPatient;
//Sync

//Color
-(UIColor*)colorWithHexString:(NSString*)hex;
//Color

//TimerToSync Data
- (void)startTimer;
- (void)stopTimer;

- (void)startTimerPull ;
- (void)stopTimerPull ;
-(void)startSyncingData;


- (void)startTimerNEWS ;
- (void)stopTimerNEWS ;
//-(void)startSyncingDataNEWS;
-(void)syncNews;

//Get NEws From server

//Processs String
-(NSString*)processHealthIndexString :(NSString*)yourString;

//ResetUserInfo
-(void)resetUserData;

//Security
-(NSString*)encryptString :(NSString*)string;
-(NSString*)decryptString  :(NSString*)encryptedString;

-(NSString *)getUniqueDeviceIdentifierAsString;
//TRIAL OR PURCHASE
-(void)authenticateApp;


//App Purchasement
-(void)setRegistrationStatus;

//REsendVerificationCode
-(void)ResendEmailVerification;

//logOUT
-(void)logoutFunctionality;


//Register USer

-(void)resetKeyChain;

- (NSString*) convertObjectToJson:(NSObject*) object;

//REading NEws from File
-(NSDictionary*)readNews; //Nil if file doesn't exist

//Publishing Admission Reference data from patient data
-(BOOL)fillAdmissionReferenceData;

#pragma mark - HANDLING DIAGNOSIS PAYMENT
-(void)tPaymentSaveDiagnosisReceiptToServer :(NSString*)receipt;

#pragma mark - SKIP iCLOUD BACKUP
- (BOOL)taddSkipiCloudBackupAttributeToItemAtURL:(NSURL *)URL;


#pragma mark - LOCATION BACE ACCESS TESTING


-(void)getCurrentLocation;
-(BOOL)LocationiSPermitedByOS;
-(void)timerFiredLocationBaseAccess;

#pragma mark - BADGE VALUE OF TAB
-(int)getBadgeValueOfTab;
@end

//
//  TSCheckOut.h
//
//
//
//


#import "TSCheckOut.h"
#import "UICKeyChainStore.h"
@implementation TSCheckOut
#pragma mark - GetUniqueDeviceIdentifierAsString

/*
 By: Yogesh Lolusare
 Purpose: Getting unique device id even if the app is deleted from device
 How It Works: The Unique ID is created & stored in Key Chain, so the app get same UDID on reinstallation of app on given device.
 Tested: YES
 Date: March 2015
 Updated: -
 Warnings: MAke sure you get updated UICKeyChainStore.h wrapper downloaded 
 Link: https://github.com/kishikawakatsumi/UICKeyChainStore
 
 */

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

@end

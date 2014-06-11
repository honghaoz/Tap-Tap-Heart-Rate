/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

#define IFPGA_NAMESTRING                @"iFPGA"

#define IPHONE_1G_NAMESTRING            @"iPhone 1G"
#define IPHONE_3G_NAMESTRING            @"iPhone 3G"
#define IPHONE_3GS_NAMESTRING           @"iPhone 3GS" 

#define IPHONE_4_1_NAMESTRING           @"iPhone 4 (GSM)"
#define IPHONE_4_2_NAMESTRING           @"iPhone 4 (GSM Rev A)"
#define IPHONE_4_3_NAMESTRING           @"iPhone 4 (CDMA)"

#define IPHONE_4S_NAMESTRING            @"iPhone 4S"

#define IPHONE_5_1_NAMESTRING           @"iPhone 5 (GSM)"
#define IPHONE_5_2_NAMESTRING           @"iPhone 5 (Global)"

#define IPHONE_5c_1_NAMESTRING          @"iPhone 5c (GSM)"
#define IPHONE_5c_2_NAMESTRING          @"iPhone 5c (Global)"

#define IPHONE_5s_1_NAMESTRING          @"iPhone 5s (GSM)"
#define IPHONE_5s_2_NAMESTRING          @"iPhone 5s (Global)"

#define IPHONE_UNKNOWN_NAMESTRING       @"Unknown iPhone"


#define IPOD_1G_NAMESTRING              @"iPod touch 1G"
#define IPOD_2G_NAMESTRING              @"iPod touch 2G"
#define IPOD_3G_NAMESTRING              @"iPod touch 3G"
#define IPOD_4G_NAMESTRING              @"iPod touch 4G"
#define IPOD_5G_NAMESTRING              @"iPod touch 5G"
#define IPOD_UNKNOWN_NAMESTRING         @"Unknown iPod"

#define IPAD_1G_NAMESTRING              @"iPad 1G"

#define IPAD_2G_1_NAMESTRING            @"iPad 2 (WiFi)"
#define IPAD_2G_2_NAMESTRING            @"iPad 2 (GSM)"
#define IPAD_2G_3_NAMESTRING            @"iPad 2 (CDMA)"
#define IPAD_2G_4_NAMESTRING            @"iPad 2 (Rev A)"

#define IPAD_3G_1_NAMESTRING            @"iPad 3 (WiFi)"
#define IPAD_3G_2_NAMESTRING            @"iPad 3 (GSM)"
#define IPAD_3G_3_NAMESTRING            @"iPad 3 (Global)"

#define IPAD_4G_1_NAMESTRING            @"iPad 4 (WiFi)"
#define IPAD_4G_2_NAMESTRING            @"iPad 4 (GSM)"
#define IPAD_4G_3_NAMESTRING            @"iPad 4 (Global)"

#define IPAD_AIR_1_NAMESTRING           @"iPad Air (WiFi)"
#define IPAD_AIR_2_NAMESTRING           @"iPad Air (Cellular)"

#define IPAD_MINI1_1_NAMESTRING         @"iPad mini 1G (WiFi)"
#define IPAD_MINI1_2_NAMESTRING         @"iPad mini 1G (GSM)"
#define IPAD_MINI1_3_NAMESTRING         @"iPad mini 1G (Global)"

#define IPAD_MINI2_1_NAMESTRING         @"iPad mini 2G (WiFi)"
#define IPAD_MINI2_2_NAMESTRING         @"iPad mini 2G (Cellular)"

#define IPAD_UNKNOWN_NAMESTRING         @"Unknown iPad"

#define APPLETV_2G_NAMESTRING           @"Apple TV 2G"
#define APPLETV_3G_NAMESTRING           @"Apple TV 3G"
#define APPLETV_4G_NAMESTRING           @"Apple TV 4G"
#define APPLETV_UNKNOWN_NAMESTRING      @"Unknown Apple TV"

#define IOS_FAMILY_UNKNOWN_DEVICE       @"Unknown iOS device"

#define SIMULATOR_NAMESTRING            @"iPhone Simulator"
#define SIMULATOR_IPHONE_NAMESTRING     @"iPhone Simulator"
#define SIMULATOR_IPAD_NAMESTRING       @"iPad Simulator"
#define SIMULATOR_APPLETV_NAMESTRING    @"Apple TV Simulator" // :)

typedef enum {
    UIDeviceUnknown,
    
    UIDeviceSimulator,
    UIDeviceSimulatoriPhone,
    UIDeviceSimulatoriPad,
    UIDeviceSimulatorAppleTV,
    
    UIDevice1GiPhone,
    UIDevice3GiPhone,
    UIDevice3GSiPhone,
    UIDevice4_1iPhone,
    UIDevice4_2iPhone,
    UIDevice4_3iPhone,
    UIDevice4SiPhone,
    UIDevice5_1iPhone,
    UIDevice5_2iPhone,
    UIDevice5c_1iPhone,
    UIDevice5c_2iPhone,
    UIDevice5s_1iPhone,
    UIDevice5s_2iPhone,
    
    UIDevice1GiPod,
    UIDevice2GiPod,
    UIDevice3GiPod,
    UIDevice4GiPod,
    UIDevice5GiPod,
    
    UIDevice1GiPad,
    UIDevice2G_1iPad,
    UIDevice2G_2iPad,
    UIDevice2G_3iPad,
    UIDevice2G_4iPad,
    UIDevice3G_1iPad,
    UIDevice3G_2iPad,
    UIDevice3G_3iPad,
    UIDevice4G_1iPad,
    UIDevice4G_2iPad,
    UIDevice4G_3iPad,
    UIDeviceAir_1iPad,
    UIDeviceAir_2iPad,
    UIDeviceMini1_1iPad,
    UIDeviceMini1_2iPad,
    UIDeviceMini1_3iPad,
    UIDeviceMini2_1iPad,
    UIDeviceMini2_2iPad,
    
    UIDeviceAppleTV2,
    UIDeviceAppleTV3,
    UIDeviceAppleTV4,
    
    UIDeviceUnknowniPhone,
    UIDeviceUnknowniPod,
    UIDeviceUnknowniPad,
    UIDeviceUnknownAppleTV,
    UIDeviceIFPGA,

} UIDevicePlatform;

typedef enum {
    UIDeviceFamilyiPhone,
    UIDeviceFamilyiPod,
    UIDeviceFamilyiPad,
    UIDeviceFamilyAppleTV,
    UIDeviceFamilyUnknown,
    
} UIDeviceFamily;

@interface UIDevice (Hardware)
- (NSString *) platform;
- (NSString *) hwmodel;
- (NSUInteger) platformType;
- (NSString *) platformString;

- (NSUInteger) cpuFrequency;
- (NSUInteger) busFrequency;
- (NSUInteger) cpuCount;
- (NSUInteger) totalMemory;
- (NSUInteger) userMemory;

- (NSNumber *) totalDiskSpace;
- (NSNumber *) freeDiskSpace;

- (NSString *) macaddress;

- (BOOL) hasRetinaDisplay;
- (UIDeviceFamily) deviceFamily;
@end
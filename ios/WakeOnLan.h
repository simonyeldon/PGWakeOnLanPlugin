//
//  WakeOnLan.h
//  PGWakeOnLan
//

#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PGPlugin.h>
#else
#import "PGPlugin.h"
#endif

@interface WakeOnLan : PGPlugin {
	
}

- (void) wake:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (BOOL) checkMACFormat:(NSString*)macAddress;

@end

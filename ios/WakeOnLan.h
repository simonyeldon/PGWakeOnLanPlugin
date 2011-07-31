//
//  WakeOnLan.h
//  PGWakeOnLan
//
//  Created by Simon on 30/07/2011.
//  
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

//
//  WakeOnLan.m
//  PGWakeOnLan
//

#import "WakeOnLan.h"
#import "RegexKitLite.h"

#ifndef MAC_PATTERN
#define MAC_PATTERN  (@"^\\s*([0-9A-Fa-f]{2}):([0-9A-Fa-f]{2}):([0-9A-Fa-f]{2}):([0-9A-Fa-f]{2}):([0-9A-Fa-f]{2}):([0-9A-Fa-f]{2})\\s*$")
#endif

@implementation WakeOnLan

- (void) wake:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
{
	NSLog(@"The wake method has been called.");
	
	NSString *macAddress = [options objectForKey:@"macAddress"];
	NSString* callbackId = [arguments objectAtIndex:0];
	
	if (![self checkMACFormat:macAddress]) {
		NSLog(@"The mac is invalid");		
		PluginResult* pluginResult = [PluginResult resultWithStatus: PGCommandStatus_ERROR messageAsString:@"Invalid mac"];
		[self writeJavascript:[pluginResult toErrorCallbackString:callbackId]];
		return;
	}
	
	PluginResult* pluginResult = [PluginResult resultWithStatus: PGCommandStatus_OK messageAsString:@"Packet broadcast"];
	[self writeJavascript:[pluginResult toSuccessCallbackString:callbackId]];
	NSLog(@"Reached the end of the method");
	return;
}

-(BOOL) checkMACFormat:(NSString*)macAddress
{
	NSLog(@"Calling checkMacFormat");
	NSArray* macParts =	[macAddress captureComponentsMatchedByRegex:(NSString*)MAC_PATTERN];
	return (7 == [macParts count]);
}

@end

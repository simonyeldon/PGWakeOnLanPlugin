//
//  WakeOnLan.m
//  PGWakeOnLan
//
//  Created by Simon on 30/07/2011.
//

#import "WakeOnLan.h"


@implementation WakeOnLan

const NSString* MAC_PATTERN = @"^\\s*([0-9A-Fa-f]{2}):([0-9A-Fa-f]{2}):([0-9A-Fa-f]{2}):([0-9A-Fa-f]{2}):([0-9A-Fa-f]{2}):([0-9A-Fa-f]{2})\\s*$";



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
		//NSArray* macParts =	[_mac captureComponentsMatchedByRegex:(NSString*)MAC_PATTERN];
	
		//return (7 == [macParts count]);
	return NO;
}


@end

//
//  WakeOnLan.m
//  PGWakeOnLan
//

/*
 Copyright 2011 Simon Yeldon

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
#import "WakeOnLan.h"
#import "RegexKitLite.h"

#import <sys/socket.h>
#import <netinet/in.h>

#ifndef IP_PATTERN
#define IP_PATTERN  (@"^\\s*(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\s*$")
#endif

#ifndef MAC_PATTERN
#define MAC_PATTERN  (@"^\\s*([0-9A-Fa-f]{2}):([0-9A-Fa-f]{2}):([0-9A-Fa-f]{2}):([0-9A-Fa-f]{2}):([0-9A-Fa-f]{2}):([0-9A-Fa-f]{2})\\s*$")
#endif

@implementation WakeOnLan

const int HEADER = 6;
const int MAC_BYTES_LEN = 6;
const int MAC_TIMES = 16;
const int PORT = 9;

- (void) wake:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
{
	
	NSLog(@"Calling wake.");
	
	NSString* callbackId = [arguments objectAtIndex:0];
	
	NSString* macAddress = [options objectForKey:@"macAddress"];	//validate the mac is correct
	NSArray* macParts = [macAddress captureComponentsMatchedByRegex:(NSString*)MAC_PATTERN];
	if ([macParts count] != 7) {
		NSLog(@"The mac is invalid, count is %@", [macParts count]);		
		PluginResult* pluginResult = [PluginResult resultWithStatus: PGCommandStatus_ERROR messageAsString:@"Invalid MAC address, please check your settings"];
		[self writeJavascript:[pluginResult toErrorCallbackString:callbackId]];
		return;
	}
	
	NSString* ipAddress = [options objectForKey:@"ipAddress"];
	//validate the mac is correct
	NSArray* ipParts = [ipAddress captureComponentsMatchedByRegex:(NSString*)IP_PATTERN];
	if ([ipParts count] != 5) {
		NSLog(@"The IP is invalid");		
		PluginResult* pluginResult = [PluginResult resultWithStatus: PGCommandStatus_ERROR messageAsString:@"Invalid IP address, please check your settings"];
		[self writeJavascript:[pluginResult toErrorCallbackString:callbackId]];
		return;
	}
	
	//build the payload
	NSData* payload = [self buildPayload:macAddress];
	
	
	// code from http://www.benripley.com/development/ios/udp-broadcasting-on-iphone-using-bsd-sockets/
	int sock;
	struct sockaddr_in destination;
	int broadcast = 1;
	
	if ((sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0)
	{
		NSLog(@"Unable to create socket");		
		PluginResult* pluginResult = [PluginResult resultWithStatus: PGCommandStatus_ERROR messageAsString:@"Unable to create socket"];
		[self writeJavascript:[pluginResult toErrorCallbackString:callbackId]];
		return;
	}  
	
	/* Construct the server sockaddr_in structure */   
	memset(&destination, 0, sizeof(destination));
	/* Clear struct */    
	destination.sin_family = AF_INET;
	/* Internet/IP */
    destination.sin_addr.s_addr = inet_addr([ipAddress UTF8String]);  
	/* IP address */   
	destination.sin_port = htons(PORT);
	/* server port */
    setsockopt(sock, IPPROTO_IP, IP_MULTICAST_IF, &destination, sizeof(destination));
	//char *cmsg = [msg UTF8String];
	//echolen = strlen(cmsg);
	
	// this call is what allows broadcast packets to be sent:
	if (setsockopt(sock, SOL_SOCKET, SO_BROADCAST, &broadcast, sizeof broadcast) == -1)
	{
		NSLog(@"Error with the socket");
	}
	if (sendto(sock, [payload bytes], [payload length], 0, (struct sockaddr *) &destination, sizeof(destination)) != [payload length])
    {    
		NSLog(@"Mismatch in number of sent bytes");
		return;  
	}  
	else
	{   
		NSLog(@"-> Tx: %@",[payload description]);
	}
	close(sock);
	
	PluginResult* pluginResult = [PluginResult resultWithStatus: PGCommandStatus_OK messageAsString:@"Packet broadcast"];
	[self writeJavascript:[pluginResult toSuccessCallbackString:callbackId]];
	
	return;
}

- (NSData*) buildPayload:(NSString*)macAddress
{
	void* bytes = malloc(HEADER);
	
	memset(bytes, 0xFF, HEADER);
	
	NSMutableData* buffer = [[NSMutableData alloc]
							 initWithBytesNoCopy:bytes
							 length:HEADER
							 freeWhenDone:YES];
	
	NSData* macData = [self parseMac:macAddress];
	
	for (int i = 0; i < MAC_TIMES; i++) {
		[buffer appendData:macData];
	}
	
	return [buffer autorelease];
}

- (NSData*) parseMac:macAddress
{
	NSArray* macParts =
	[macAddress captureComponentsMatchedByRegex:(NSString*)MAC_PATTERN];
	
	if (nil == macParts) {
		return nil;
	}
	
	void* buffer = malloc(MAC_BYTES_LEN);
	
	char * pMacPart = malloc(3);
	bzero(pMacPart, 3);
	for (int i = 0; i < [macParts count] - 1; i++) {
		NSString* part = [macParts objectAtIndex:i + 1];
		
		if([part getCString:pMacPart maxLength:3 encoding:NSASCIIStringEncoding])
		{
			memset(buffer + i, strtol(pMacPart, (char **)NULL, 16), 1);
		}
	}
	
	free(pMacPart);
	
	return [NSData dataWithBytesNoCopy:buffer length:MAC_BYTES_LEN freeWhenDone:YES];
}

@end

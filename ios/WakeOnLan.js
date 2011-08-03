/**
 * PhoneGap Wake-On-Lan Plugin
 * 
 * Copyright 2011 Simon Yeldon
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 *
 * Usage: 
 * window.plugins.wol.wake(macAddress, ipAddress successCallback, failCallback);
 */

 var WakeOnLan = function() {}

 WakeOnLan.prototype.wake = function(mac, ip, success, fail) {
 	console.log("Calling WakeOnLan.wake");
 	var options = {
 		macAddress: mac,
 		ipAddress: ip
 	}
 	PhoneGap.exec(success, fail, "WakeOnLan", "wake", [options]);
 }

 PhoneGap.addConstructor(function() {
 	if(!window.plugins) {
 		window.plugins = {};
 	}
 	window.plugins.wol = new WakeOnLan();
 });
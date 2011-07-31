/**
 * PhoneGap Wake-On-Lan Plugin
 * Copyright (c) Simon Yeldon 2011
 *
 * Usage: 
 * window.plugins.wol.wake(macAddress, successCallback, failCallback);
 */

var WakeOnLan = function() {}

WakeOnLan.prototype.wake = function(mac, success, failure) {
	console.log("Calling WakeOnLan.wake");
	var options = {
		macAddress: mac
	}
	PhoneGap.exec(success, failure, "WakeOnLan", "wake", [options]);
}


PhoneGap.addConstructor(function() {
	if(!window.plugins) {
		window.plugins = {};
	}
	window.plugins.wol = new WakeOnLan();
});
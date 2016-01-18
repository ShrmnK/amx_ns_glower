/*
Glower by Whosat?! version 3.0
Send an email to whosat@goowy.com for queries.
Credits: devicenull, for his AllGlow.
	 semaja2, for helping me fix some bugs
	 gr1mre4p3r, for some ideas.
	 unnamed -sg for his RGB colour chart and for testing on his server.
=D =D =D

Tested on a Win32 HLDS AMXx v1.76b & Metamod v1.19 & NS v3.1.3
Use on NS v3.2 Beta at your own risk! (NOT TESTED. =P)
*/

/* ChangeLog
v1.0
Red Glow for all players

v1.1
Added random colour glowing
Increased amount of glow

v1.2 
Added stealth
Removed useless code

v1.3 
Added command to make self stealth

v1.4
Added StealthGlow effect. say/2gt.

v1.5
Changed command for making StealthGlow effect to make it shorter.

v1.6
Removed /stealth as it was too cheat.

v1.7
Fixed StealthGlow not stealthing

v1.8
Changed Stealthing method, less code needed this way.
Removed making all players StealthGlow after joining server.

v1.9
Added a command to make the player revert back to normal.

v2.0
Tested stealth
Changed /2gt to /sglow

v2.1
Completely removed stealth as it crashes the server. (No idea why 0.o)
Added Helper support

v2.2
Added cvar to disable/enable glower

v2.3
Fixed Glower not disabling when amx_glow is 0

v2.4
Fixed showing that glower is disabled when it is not
Fixed message not showing that glower is disabled when any command is called.

v2.5
Fixed glow showing StealthGlow. (Mixed up the codes, XD)

v2.6
Fixed not StealthGlowing when in RR.

v2.7
Added defines for glowing/StealthGlowing in rr. See RRglow and RRsglow

v2.8
Added cvar to enable/disable StealthGlow on-the-fly. (Thanks, gr1mre4p3r for idea. =D)

v2.9
Shows message to clients when StealthGlow is disabled.
Players will now glow when StealthGlow is disabled (Message will be displayed).
Shows in helper when RR glow and RR StealthGlow is disabled.
Added define to make players glow when they connect.
Removed showing glower version when any message from glower is displayed. (Shows v50 XD)
Added message to client when command is called and cvar is enabled that he/she(?) is glowing/StealthGlowing.

v3.0
Cleaned up code
Shows a message to clients when they connect that the server is running Glower.
Released on ModNS
*/

// Defines
#define HELPER 1		// Defines if helper is running
#define RRglow 1		// Defines if players can glow in the readyroom
#define RRsglow 1		// Defines if players can StealthGlow in the readyroom
#define CONNECTGLOW 1		// Defines if players glow on connecting to the server

#include <amxmodx>
#include <engine>
//#include <engine_stocks>
#include <fun>
#include <ns>

#if HELPER == 1			// make sure we only include the helper if we actually want to use it! server ops may not have this file and therefor do not wish to include it, although it doesn't harm if the Helper is disabled
#include <helper>
#endif

new plugin_author[] = "Whosat?!"
new plugin_version[] = "3.0"

public plugin_init() {
	register_plugin("Glower",plugin_version,plugin_author)
	register_clcmd("say /glow","makeglow")
	register_clcmd("say_team /glow","makeglow")
	register_clcmd("say /sglow","stealthglow")
	register_clcmd("say_team /sglow","stealthglow")
	register_clcmd("say /stopglow","revert")
	register_clcmd("say_team /stopglow","revert")
	register_cvar("amx_glow", "1")
	register_cvar("amx_sglow", "1")
	server_print("Glower 3.0 by Whosat?! loaded.")
}

// Makes players glow on connect.
public client_putinserver(id) {
#if CONNECTGLOW == 1
set_task(5.0,"makeglow",id)
#endif
set_task(10.0,"showGlow",id)
}

public makeglow(id) {
	new team[32]
	new Red = random(256)
	new Green = random(256)
	new Blue = random(256)
	if ( get_cvar_float( "amx_glow" ) == 1 ) {
//		if ( get_cvar_float( "amx_fadeglow" ) == 0 ) {
//			if (ns_get_class == CLASS_FADE) 
//				client_print(id, print_chat, "Glower: Glowing not allowed when class is fade.")
//		}else{
		get_user_team(id,team,32)
		if (equal(team,"marine1team") || equal(team,"alien1team"))
			set_user_rendering(id,kRenderFxGlowShell,Red,Green,Blue,kRenderNormal,16)
		if (equal(team,"marine2team") || equal(team,"alien2team"))
			set_user_rendering(id, kRenderFxGlowShell, Red, Green, Blue, kRenderNormal, 16)
		#if RRglow == 1
		if (equal(team,"undefinedteam") || strlen(team) == 0)
			set_user_rendering(id,kRenderFxGlowShell,Blue,Red,Green,kRenderNormal,16)
		#endif
		#if RRglow == 0
		if (equal(team,"undefinedteam") || strlen(team) == 0)
			set_user_rendering(id,kRenderFxNone,0,0,0,kRenderNormal,16)
		#endif
		client_print(id, print_chat, "Glower: Now glowing.")
	}else{
		client_print(id, print_chat, "Glower: Glower disabled by Admin.")
	}
}

// StealthGlow.
public stealthglow(id) {
	new team[32]
	new Red = random(256)
	new Green = random(256)
	new Blue = random(256)
	if ( get_cvar_float( "amx_glow" ) == 1 ) {
		get_user_team(id,team,32)
		if (equal(team,"marine1team") || equal(team,"alien1team"))
			set_user_rendering(id,kRenderFxGlowShell,Red,Green,Blue,kRenderNormal,22)
		if (equal(team,"marine2team") || equal(team,"alien2team"))
			set_user_rendering(id, kRenderFxGlowShell, Red, Green, Blue, kRenderNormal, 22)
		#if RRsglow == 1
		if (equal(team,"undefinedteam") || strlen(team) == 0)
			set_user_rendering(id,kRenderFxGlowShell,Blue,Red,Green,kRenderTransAlpha,16)
		#endif
		#if RRsglow == 0
		if (equal(team,"undefinedteam") || strlen(team) == 0)
			set_user_rendering(id,kRenderFxNone,0,0,0,kRenderNormal,16)
		#endif
		if ( get_cvar_float( "amx_sglow" ) == 1 ) {
			get_user_team(id,team,32)
			if (equal(team,"marine1team") || equal(team,"alien1team"))
				set_user_rendering(id,kRenderFxGlowShell,Red,Green,Blue,kRenderTransAlpha,22)
			if (equal(team,"marine2team") || equal(team,"alien2team"))
				set_user_rendering(id, kRenderFxGlowShell, Red, Green, Blue, kRenderTransAlpha, 22)
			#if RRsglow == 1
			if (equal(team,"undefinedteam") || strlen(team) == 0)
				set_user_rendering(id,kRenderFxGlowShell,Blue,Red,Green,kRenderTransAlpha,16)
			#endif
			#if RRsglow == 0
			if (equal(team,"undefinedteam") || strlen(team) == 0)
				set_user_rendering(id,kRenderFxNone,0,0,0,kRenderNormal,16)
			#endif
			client_print(id, print_chat, "Glower: Now StealthGlowing.")
			}
		if ( get_cvar_float( "amx_sglow" ) == 0 ) {
				get_user_team(id,team,32)
			if (equal(team,"marine1team") || equal(team,"alien1team"))
				set_user_rendering(id,kRenderFxGlowShell,Red,Green,Blue,kRenderNormal,22)
			if (equal(team,"marine2team") || equal(team,"alien2team"))
				set_user_rendering(id, kRenderFxGlowShell, Red, Green, Blue, kRenderNormal, 22)
			#if RRsglow == 1
			if (equal(team,"undefinedteam") || strlen(team) == 0)
				set_user_rendering(id,kRenderFxGlowShell,Blue,Red,Green,kRenderTransAlpha,16)
			#endif
			#if RRsglow == 0
			if (equal(team,"undefinedteam") || strlen(team) == 0)
				set_user_rendering(id,kRenderFxNone,0,0,0,kRenderNormal,16)
			#endif
			client_print(id, print_chat, "Glower: StealthGlow disabled by Admin, now glowing instead.")
			}
	}else{
		client_print(id, print_chat, "Glower: Glower disabled by Admin.")	
	}
}
public revert(id) {
	new team[32]
	if ( get_cvar_float( "amx_glow" ) == 1 ) {
		if (equal(team,"marine1team") || equal(team,"alien1team"))
			set_user_rendering(id,kRenderFxNone,0,0,0,kRenderNormal,16)
		if (equal(team,"marine2team") || equal(team,"alien2team"))
			set_user_rendering(id,kRenderFxNone,0,0,0,kRenderNormal,16)
		if (equal(team,"undefinedteam") || strlen(team) == 0)
			set_user_rendering(id,kRenderFxNone,0,0,0,kRenderNormal,16)
		client_print(id, print_chat, "Glower: Resetted back to normal.")
	}else{
		client_print(id, print_chat, "Glower: Glower Disabled by an Admin.")	
	}
}

public showGlow(id) {
	new Red = random(256)
	new Green = random(256)
	new Blue = random(256)
	set_hudmessage(Red, Green, Blue, -1.0, 0.01)
	show_hudmessage(id, "This Server is running Glower. Say /sglow to StealthGlow, /glow to Glow.")
}
// Helper Info
#if HELPER == 1					// if helper is running, see define HELPER
/************************************************
client_help( id )
Public Help System
************************************************/

public client_help(id){
  help_add("Information","This plugin allows users to glow a random colour")
  help_add("Commands","/glow^n/sglow^n/stopglow")
  help_add("About","/glow: Makes player glow^n/sglow: Makes player StealthGlow^n /stopglow: Makes player revert back to normal")
  #if RRglow == 0
  help_add("Glowing","Glowing in RR is not allowed.")
  #endif
  #if RRsglow == 0
  help_add("StealthGlowing","StealthGlowing in RR is not allowed.")
  #endif
  help_add("Tips","Keep saying the same command to change to another colour. =D")
}

public client_advertise(id)	return PLUGIN_CONTINUE
#endif

/*
Glower by Whosat?! version 3.1
Send an email to whosat@goowy.com for queries.
Credits: OneEyed's roll the dice plugin.
	 semaja2, for his mines for levels' helper support part. also for helping me with the is_user_alive part.
		  also for helping me alot with coding, and compiling for me.
	 gr1mre4p3r, for some ideas.
	 unnamed -sg for his RGB colour chart and for testing on his server and compiling for me.
	 Morpheus, for helping me with using the engine module. (not implemented yet.)
=D =D =D =D =D

Tested on a Win32 SAHLDS AMXx v1.76b & Metamod v1.19 & NS v3.1.3 (Not tested on this from v3.1 onwards)
Tested on a Win32 Listen Server AMXx v1.76c & Metamod v1.19 & NS v3.1.3
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

v3.1
Now disables fades and jetpackers from StealthGlowing (makes them 'invisible') (adjustable on next release)
Now disables people from glowing/StealthGlowing when they're dead. (displays message)
Some code rewritten by semaja2, thanks loads man.
*/

// Defines
#define HELPER 1		// Defines if helper is running
#define RRglow 1		// Defines if players can glow in the readyroom
#define RRsglow 1		// Defines if players can StealthGlow in the readyroom
#define CONNECTGLOW 1		// Defines if players glow on connecting to the server

#include <amxmodx>
#include <engine>
#include <fun>
#include <ns>
#if HELPER == 1			// Defines if helper support should be enabled.
#include <helper>
#endif

new plugin_author[] = "Whosat?!"
new plugin_version[] = "3.1"

public plugin_init() {
	register_plugin("Glower",plugin_version,plugin_author)
	register_clcmd("say /glow","makeglow")
	register_clcmd("say_team /glow","makeglow")
	register_clcmd("say /sglow","sglowsplit")
	register_clcmd("say_team /sglow","sglowsplit")
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
	set_task(60.0,"showGlow",id)
	set_task(300.0,"showGlow",id)
	return PLUGIN_CONTINUE
}

// Splits sglow.
public sglowsplit(id) {
	new class = ns_get_class(id)
	if ( class == CLASS_FADE || class == CLASS_JETPACK )   // JP or fade
	{
		client_print(id, print_chat, "Glower v%s: StealthGlowing not allowed when class is fade or when having a JP", plugin_version)
		return PLUGIN_HANDLED
	}
	if ( !get_cvar_num( "amx_sglow" )) 
	{
		set_task(0.1,"makeglow",id)
		client_print(id, print_chat, "Glower v%s: StealthGlow disabled by Admin, now glowing instead.", plugin_version)
	}
	else
	{
		set_task(0.1,"stealthglow",id)
	}
	return PLUGIN_CONTINUE
}

// THE glow
public makeglow(id) {
	if (!get_cvar_num( "amx_glow"))
	{
		client_print(id, print_chat, "Glower v%s: Glow disabled by Admin.", plugin_version) 
		return PLUGIN_HANDLED
	}
	
	if (!is_user_alive(id)) 
	{
		client_print(id, print_chat, "Glower v%s: I don't glow dead people.", plugin_version)
		return PLUGIN_HANDLED
	}
	new team[32]
	new Red = random(256)
	new Green = random(256)
	new Blue = random(256)
	
	get_user_team(id,team,32)
	if (equal(team,"marine1team") || equal(team,"alien1team"))
	{
		set_user_rendering(id,kRenderFxGlowShell,Red,Green,Blue,kRenderNormal,16)
	}
	if (equal(team,"marine2team") || equal(team,"alien2team"))
	{
		set_user_rendering(id, kRenderFxGlowShell, Red, Green, Blue, kRenderNormal, 16)
	}
	#if RRglow == 1
	if (equal(team,"undefinedteam") || strlen(team) == 0)
	{
		set_user_rendering(id,kRenderFxGlowShell,Blue,Red,Green,kRenderNormal,16)
	}
	#else
	if (equal(team,"undefinedteam") || strlen(team) == 0)
	{
		set_user_rendering(id,kRenderFxNone,0,0,0,kRenderNormal,16)
	}
	#endif
	client_print(id, print_chat, "Glower v%s: Now glowing.", plugin_version)
	
	return PLUGIN_HANDLED
}

// THE StealthGlow.
public stealthglow(id) {
		new team[32]
	new Red = random(256)
	new Green = random(256)
	new Blue = random(256)
	
	if (!is_user_alive(id)) {
		client_print(id, print_chat, "Glower v%s: I don't StealthGlow dead people.", plugin_version)
		return PLUGIN_HANDLED
	}
	get_user_team(id,team,32)
	if (equal(team,"marine1team") || equal(team,"alien1team"))
	{
		set_user_rendering(id,kRenderFxGlowShell,Red,Green,Blue,kRenderTransAlpha,22)
	}
	if (equal(team,"marine2team") || equal(team,"alien2team"))
	{
		set_user_rendering(id, kRenderFxGlowShell, Red, Green, Blue, kRenderTransAlpha, 22)
	}
	#if RRsglow == 1
	if (equal(team,"undefinedteam") || strlen(team) == 0)
	{
		set_user_rendering(id,kRenderFxGlowShell,Blue,Red,Green,kRenderTransAlpha,16)
	}
	#else
	if (equal(team,"undefinedteam") || strlen(team) == 0)
	{
		set_user_rendering(id,kRenderFxNone,0,0,0,kRenderNormal,16)
	}
	#endif
	client_print(id, print_chat, "Glower v%s: Now StealthGlowing.", plugin_version)
	return PLUGIN_HANDLED
}

// Revert player back to normal
public revert(id) {
	new team[32]
	if (equal(team,"marine1team") || equal(team,"alien1team"))
	{
		set_user_rendering(id,kRenderFxNone,0,0,0,kRenderNormal,16)
	}
	if (equal(team,"marine2team") || equal(team,"alien2team"))
	{
		set_user_rendering(id,kRenderFxNone,0,0,0,kRenderNormal,16)
	}
	if (equal(team,"undefinedteam") || strlen(team) == 0)
	{
		set_user_rendering(id,kRenderFxNone,0,0,0,kRenderNormal,16)
	}
	client_print(id, print_chat, "Glower v%s: Resetted back to normal.", plugin_version)
	return PLUGIN_HANDLED
}

// Shows a HUD message that glower is running
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
  help_add("Notes","Jetpackers and Fades are not allowed to StealthGlow")
  help_add("Tips","Keep saying the same command to change to another colour. =D")
}

public client_advertise(id)	return PLUGIN_CONTINUE
#endif
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1033\\ f0\\ fs16 \n\\ par }
*/

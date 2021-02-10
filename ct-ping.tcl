#############################################
# CT-Ping.tcl 0.1                 #09/02/21 #
#############################################
#Author  ComputerTech                       #
#IRC     Irc.DareNet.Org  #ComputerTech     #
#Email   ComputerTech@DareNet.Org           #
#GitHub  https://github.com/computertech312 #
#################################################################################################################################################################
# Start Of Configuration #
##########################
#Set trigger of the Command.

set ctping(trig) "@"


##################
#Set flag for Commands.
##
#Owner     = n
#Master    = m
#Op        = o
#Voice     = v
#Friend    = f
#Everyone  = -
set ctping(flag) "-|-"


##################
#Set to use Notice Or Channel for Output of Command
##
#1 = Notice
#0 = Channel

set ctping(msg) "0"


##################
#Set Colour of Output
##
#White       = 0
#Black       = 1
#Dark Blue   = 2
#Green       = 3
#Red         = 4
#Brown       = 5
#Purple      = 6
#Orange      = 7
#Yellow      = 8
#Light Green = 9
#DarkCyan    = 10
#LightCyan   = 11
#LightBlue   = 12
#Pink        = 13
#Dark Grey   = 14
#Light Grey  = 15


set colo "3"


##################
#Set Time per usage of Command
##

set ctping(time) "5"


########################
# End Of Configuration #
#################################################################################################################################################################

bind pub $ctping(flag) $ctping(trig)ping ct:pub:ping
bind ctcr - PING ct:pingr


proc ct:pub:ping {nick host hand chan text} {
global pingchan pingwho
	set pingwho [lindex [split $text] 0]
	if {$pingwho == ""} {set pingwho $nick}
	putquick "PRIVMSG $pingwho :\001PING [clock clicks -milliseconds]\001"
	set pingchan($pingwho) $chan
}
proc ct:pingr {nick uhost hand dest keyword text} {
	global pingchan ctping colo pingwho
	set time [expr {([clock clicks -milliseconds] - $text) / 1000.000}]
	set char "="
	if {[expr {round($time / 0.5)}] > 10} {set red 10} else {set red [expr {round($time / 0.5)}]}
	set green [expr {10 - $red}]
	set output \00303[string repeat $char $green]\003\00304[string repeat $char $red]\003
	if {($ctping(msg) == "0")} {
		putquick "PRIVMSG $pingchan($pingwho) :\[\0030${colo}PING\003\] reply from $pingwho: \[\0030${colo}$time\003\] seconds $output"
	} else {
		putquick "NOTICE $nick :\[\0030${colo}PING\003\] reply from $pingwho: \[\0030${colo}$time\003\] seconds"
	}
unset pingchan
}

#################################################################################################################################################################

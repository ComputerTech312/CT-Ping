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

set ctping(trig) ";"


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

set ctping(time) "30"


########################
# End Of Configuration #
#################################################################################################################################################################

bind pub $ctping(flag) $ctping(trig)ping ct:pub:ping
bind ctcr - PING ct:pingr

proc throttled {id seconds} {
   global throttle
   if {[info exists throttle($id)]&&$throttle($id)>[clock seconds]} {
      set id 1
   } {
      set throttle($id) [expr {[clock seconds]+$seconds}]
      set id 0
   }
}
bind time - ?0* throttledCleanup
proc throttledCleanup args {
   global throttle
   set now [clock seconds]
   foreach {id time} [array get throttle] {
      if {$time<=$now} {unset throttle($id)}
   }
}
set pingchan ""

proc pub:ping {nick host hand chan text} {
  global pingchan pingwho ctping
      if {[throttled $host,$chan $ctping(time)]} {
    putserv "NOTICE $nick :Command Throttled"
    return 
   }
  set pingwho [lindex [split $text] 0]
     if {$pingwho == ""} {set pingwho $nick}
  putquick "PRIVMSG $pingwho :\001PING [clock clicks -milliseconds]\001"
  set pingchan $chan
 }
 proc ct:pingr {nick uhost hand dest keyword args} {
  global pingchan ctping colo pingwho
  set time [expr {([clock clicks -milliseconds] - $args) / 1000.000}]
      set char "="
      if {[expr {round($time / 0.5)}] > 10} {set red 10} else {set red [expr {round($time / 0.5)}]}
      set green [expr {10 - $red}]
      set output \00303[string repeat $char $green]\003\00304[string repeat $char $red]\003
  if {($ctping(msg) == "0")} {
   putquick "PRIVMSG $pingchan :\[\0030${colo}PING\003\] reply from $pingwho: $output \[\0030${colo}$time\003\] seconds"
  } else {
   putquick "NOTICE $nick :\[\0030${colo}PING\003\] reply from $pingwho: \[\0030${colo}$time\003\] seconds"
  }
 }
#################################################################################################################################################################

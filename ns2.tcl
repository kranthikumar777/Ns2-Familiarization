#Creating a new Simulator
set ns [new Simulator]

#Tracing
set f [open tcp.tr w]
$ns trace-all $f
set nf [open tcp.nam w]
$ns namtrace-all $nf

#Taking input from the command line
if { $argc != 2 } {
        puts "Error in syntax \n Try as shown \n."    
	puts "ns2.tcl <TCP_flavor(vegas or sack)> <case_no (1||2||3)>\n"
	puts "Please try again \n"
    }
set TCP_flavor [lindex $argv 0]
set case_no [lindex $argv 1]
global flavor,delay
set delay 0

# Defining delay for three cases
if {$case_no == 1} {
	set delay "12.5ms"
	}
if {$case_no == 2} {
	set delay "20ms"
	}
if {$case_no == 3} {
	set delay "27.5ms"
	}
if {$case_no <1 && $case_no>3} {
	puts "Invalid case number \n"
	}

# Defining the type of TCP flavor
if {$TCP_flavor == "SACK" || $TCP_flavor=="sack"} {
	set flavor "Sack1"
} elseif {$TCP_flavor == "VEGAS" || $TCP_flavor=="vegas"} {
	set flavor "Vegas"
} else {
	puts "Invalid TCP Flavor $flavor"
	exit
}

puts "TCP flavor = $flavor"
puts "case No = $case_no"

#Initializing variables
set throughput1 0
set throughput2 0
set ratio 0


#create network topology
set src1 [$ns node]
set src2 [$ns node]
set r1 [$ns node]
set r2 [$ns node]
set rec1 [$ns node]
set rec2 [$ns node]

#Define colors for flow of data
$ns color 1 Blue
$ns color 2 Red

#Create links
$ns duplex-link $src1 $r1 10.0Mb 5ms DropTail
$ns duplex-link $src2 $r1 10.0Mb $delay DropTail
$ns duplex-link $r1 $r2 1.0Mb 5ms DropTail
$ns duplex-link $r2 $rec1 10.0Mb 5ms DropTail
$ns duplex-link $r2 $rec2 10.0Mb $delay DropTail

$ns duplex-link-op $src1 $r1 orient right-down
$ns duplex-link-op $src2 $r1 orient right-up
$ns duplex-link-op $r1 $r2 orient right
$ns duplex-link-op $r2 $rec2 orient right-down
$ns duplex-link-op $r2 $rec1 orient right-up

#Setting up TCP 
set tcp1 [new Agent/TCP/$flavor]
set tcp2 [new Agent/TCP/$flavor]
set sink1 [new Agent/TCPSink]
set sink2 [new Agent/TCPSink]
$tcp1 set class_ 1
$tcp2 set class_ 2
$ns attach-agent $src1 $tcp1
$ns attach-agent $rec1 $sink1
$ns attach-agent $src2 $tcp2
$ns attach-agent $rec2 $sink2
$ns connect $tcp1 $sink1
$ns connect $tcp2 $sink2

#Setting FTP over TCP
set ftp1 [new Application/FTP]
set ftp2 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp2 attach-agent $tcp2

#Creating Record
proc record {} {
	global sink1 sink2 throughput1 throughput2 ratio
	set ns [Simulator instance]
	set time 0.5
	set bw1 [$sink1 set bytes_]
	set bw2 [$sink2 set bytes_]
	set now [$ns now]
	#neglecting the first 100 sec
	if {$now>=100 && $now<=400} {
		set throughput1 [expr $throughput1+$bw1/$time*8/1000000]
		set throughput2 [expr $throughput2+$bw2/$time*8/1000000]
	}
	
	if {$now == 400} {
		puts "Average Throughput for Src1 is = [expr $throughput1*$time/300] Mbps \n"
		puts "Average Throughput for Src2 is = [expr $throughput2*$time/300] Mbps \n"
		set ratio [expr $throughput1/$throughput2]
		puts "Throughput Ratio is = $ratio"
	}
	#Reset the bytes to 0
	$sink1 set bytes_ 0
	$sink2 set bytes_ 0
	#Reschedule
	$ns at [expr $now+$time] "record"
}

#Start nam
proc finish {} {
global ns nf f throughput1 throughput2 ratio  
$ns flush-trace
close $nf
close $f
puts "Opening NAM"
exec nam tcp.nam &
exit 0
}

#Timing the ns commands
$ns at 0 "record"
$ns at 0 "$ftp1 start"
$ns at 0 "$ftp2 start"
$ns at 400.5 "$ftp1 stop"
$ns at 400.5 "$ftp2 stop"
$ns at 400.5 "finish"

$ns run






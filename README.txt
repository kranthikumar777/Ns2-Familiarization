# Ns2-Familiarization
#ECEN 602 Network Programming Assignment 4
Implementing a small network in Ns2
----------------------------------------------
Team Number:23
Member 1: Kranthi Kumar Katam  (UIN: 225009204)
Member 2: Matthew Roe          (UIN: 321007055)
Member 3: Jifang Mu            (UIN: 821005313)
-----------------------------------------------
The package contains 3 files
1. ns2.tcl #The programming code carried out in Tcl coding
2. Ns2 Familiarization Report
3. Readme.txt
-----------------------------------------------
Design:
1. Create a new simulator, and then trace all the data to tcp.tr file.
2. The network topology is designed as in the given assignment.
3. Take input from the command line such as Tcp flavor and the case number.
4. As given in the assignment change the delay values according to the case number.
5. Set the tcp flavor as defined by the user and connect it to source1 and similarly to the other source also.
6. Set up tcp sinks to receive data and connect them to receivers at the other end.
7. Set up FTP application to send data over TCP.
8. Create a function proc record to calculate throughput of the sources at 0.5ms time intervals and finally after 400ms find the average throughput of the sources and their ratios.
9. Create a function proc finish to execute the NAM file to analyse the data flow in the topology.
10. Both sources start sending at data at time 0 and ends at 400ms time.
-----------------------------------------------
Implementation:
1. In the command line open the directory where you have saved the file.
2. Use the following command line to execute ns2.tcl
     ns ns2.tcl <TCP Flavor(all Caps)> <case number(1 or 2 or 3)>

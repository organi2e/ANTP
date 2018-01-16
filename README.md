### What's this
------
A utility to synchronous system [RTC](https://en.wikipedia.org/wiki/Real-time_clock) between several nearby machines they are offline or cannot connect to any public ntp servers.  

### Build dependency
------
XCode9.x, Swift 4.x and macOS 10.13.x

### How to use
------
Run the utility with administrator privilege on nearby machines should be synchronous.  
such as ```sudo ANTP```  

### Logging the work
------
Use ```log``` command to display the log.  
i.e. ```log stream --info --predicate 'subsystem == "ANTP"'``` and launch the utility.  

### Split group of nearby machines
------
This utility builds a p2p network. The network has a name from *process name.* In short, renamed the process will build another p2p network group.  
i.e. the operations ```mv ANTP ANTP-another
sudo ANTP-another``` will build another synchronous group.   

### How to specify leader machine of RTC
------
This utility assume the machines has own host name, and refer RTC to the machine has first host name from sorted that.  
In short, rename the host with younger name such as *A.local*, and run the utility.


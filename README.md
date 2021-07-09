# Modifications to the xv6 operating system

## USAGE:
	make clean && make SCHEDPOLICY=<FLAG> && make qemu SCHEDPOLICY=<FLAG>

The appropriate scheduler flag is chosen.

## Syscall Overview

### Adding a new system call
- To add a new syscall following files have to be modified:
1. user.h
2. usys.S
3. syscall.h
4. syscall.c
5. sysproc.c
6. defs.h
7. proc.c
8. proc.h


### waitx syscall :
	status = waitx(&a, &b);
The waitx syscall takes in two parameters and return the creation time, end-time, and total time of a process along with the run time and waittime of the process.
	

#### Tester file - time command 

- time inputs a command and exec it normally
- Uses waitx instead of normal wait
- Displays creation time, end-time, and total time along with status that is the same as that returned by wait() syscall


### ps syscall :
	cprintf("PID Priority   State   rtime wtime n_run curr_q q0 q1 q2 q3 q4 \n");
The ps syscall gives a detailed list of all the processes present in the system at that particular instant.
	

### setPriority syscall :
	setPriority(atoi(argv[2]),atoi(argv[1]);	
The set_priority syscall takes in two parameters (PRIORITY,PID) and sets the priority of the process with that PID to the one passed as PRIORITY parameter.
	

## Scheduler Overview

### FCFS :
As the name suggests, the process that arrives first is assigned CPU time first. Only once it is done, another process is assigned for that CPU. This is a non-preemptive policy. Hence, if a longer CPU burst time arrives first and one with a shorter CPU burst time arrives next, the second process will have to wait till the longer process is done (in case of 1 CPU). Processes are picked based on the least creation time.

### ROUND ROBIN - DEFAULT :
This is the default scheduling algorithm. The processes are preemted from the CPU they were assigned to once their time slice expires. This ensures that all processes in the ready queue are given CPU attention.

### PRIORITY :
Each process is assigned a default priority of 60. If the processes are of equal priority, then they execute round robin. The processes with higher priority are chosen and given CPU attention before the ones with lower priority. (A lower value of priority indicates a higher priority). The set_priority syscall can be used to change the priority of the processes. Processes are picked based on the highest priority.

### MULTI-LEVEL FEEDBACK QUEUE :
- There are five priority queues, with the highest priority being number as 0 and the bottom queue with the lowest priority as 4. The time slices of the 5 queues are {1,2,4,8,16}. If the number of ticks that a process receives in that queue exceeds the permissible number of ticks, it is downgraded to a lower queue.
- A new process always starts in the Q0, after which it is moved down as time proceeds.
- If the process used the complete time slice assigned for its current priority queue, it is pre-empted and inserted at the end of the next lower level queue.
- A round-robin scheduler should be used for processes at the lowest priority queue.
- To prevent starvation, ageing is implemented wherein if a process has been waiting for CPU attention for more than its wait time, and it is moved one queue up.

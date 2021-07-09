#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "fs.h"

int main(int argc, char *argv[])
{
	int status = 0;
	int pid;
	if (2 > argc)
	{
		printf(1, "Usage: time <process>\n");
		exit();
	}
	else
	{
		pid = fork();
		if (pid == 0)
		{
			if(exec(argv[1], &argv[1])==-1)
			{
				printf(1, "Exec %s Failed\n", argv[1]);
				exit();
			}
		}
		else if(pid>0)
		{
			int a, b;
			status = waitx(&a, &b);
			printf(1, "Wait Time = %d\nRun Time = %d \nWith Status %d \n", a, b, status);
		}
	}

	exit();
}
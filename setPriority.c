#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "fs.h"

int main(int argc, char *argv[])
{

	int pid;
	int status = 0, a, b;
	if (argc < 3)
	{
		printf(1, "Usage: setPriority <pid> <priority>\n");
		exit();
	}
	else
	{
        if(setPriority(atoi(argv[2]),atoi(argv[1]))<0)
            printf(1,"Error: No such process\n");
	}

	exit();
}
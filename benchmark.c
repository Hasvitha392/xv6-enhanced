#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "fs.h"

int main(int argc, char *argv[])
{

    int j;
    for(j=0;j<10;j++)
    {
        int p=fork();
        if(p < 0)
        {
            printf(1,"Fork failed\n");
        }
        if(p==0)
        {
            volatile int i;
            for (volatile int k = 0; k < 10; k++)
            {
                if(k>j)
                {
                    for (i = 0; i < 100000000; i++)
                    {
                        ; //cpu time
                    }
                }
                else
                {
                    sleep(200); //io time
                }
            }
            exit();    
        }

    }
for (int i = 0; i < 15; i++)
        wait();

    exit();
}
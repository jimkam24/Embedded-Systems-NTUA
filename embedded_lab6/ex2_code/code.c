]#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>


#define __NR_greeting 386

int main(void)
{
    int team_no = 25;

    long ret = syscall(__NR_greeting, team_no);

    if (ret == 0){
        printf("System call executed successfully\n");
	system("dmesg | grep Greeting");
	}
    else
        perror("System call failed");

    return 0;
}



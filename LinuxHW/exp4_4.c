#include <stdio.h> 
#include <string.h> 
#include <sys/wait.h>
#include <sys/types.h>
#include <stdlib.h>  
#include <unistd.h>
#include <errno.h> 
 
int main()
{
    int pipe_fd1[2], pipe_fd2[2];   //两个管道
    char readbuff[100];             //读取缓冲区
    int len;                        //字符长度
    pid_t pid0, pid1, pid2, pid3;   //四个进程
    
    //建立两个管道文件，失败则退出
    if( pipe(pipe_fd1)<0 || pipe(pipe_fd2)<0 ){
		printf("Cannot make pipe!\n");
        exit(1);
    }
	
    //父进程建立子进程1和2，子进程1建立子进程3
	pid1 = fork();
	pid2 = fork();
    
    //若进程建立失败则退出
	if(pid1<0 || pid2<0){
        printf("Cannot make child process!\n");
        exit(1);
	}
    
    //若两个返回值均为0，则是子进程3
	if(pid1==0 && pid2==0){
		printf("I am child process p3, PID = %d\n",getpid());   //声明，打印进程号
        char *arg[]={"ls","-l",NULL};
		execv("/usr/bin/ls",arg);                               //执行ls -l
        exit(0);
    }
    
    //子进程1
	else if(pid1==0 && pid2>0){
		printf("I am child process p1, PID = %d\n",getpid());   //声明，打印进程号
		close(pipe_fd1[0]);
        write(pipe_fd1[1],"Child process p1 is sending a message!",38);//向管道中发送字符串 
        close(pipe_fd1[1]);
        close(pipe_fd2[1]);
        if((len=read(pipe_fd2[0],readbuff,100))>0)          //若从管道中收到字符串则打印
        	printf("Child process p1 get %d character:\n\t%s\n",len,readbuff);
		else{
			printf("Error!\n");
			exit(1);
		}
        close(pipe_fd2[0]);
		exit(0);
	}
    
    //子进程2
	else if(pid1>0 && pid2==0){
		printf("I am child process p2, PID = %d\n",getpid());   //声明，打印进程号
		close(pipe_fd1[1]);
        if((len=read(pipe_fd1[0],readbuff,100))>0)           //若从管道中受到字符串则打印
        	printf("Child process p2 get %d character:\n\t%s\n",len,readbuff);
        else{
			printf("Error!\n");
			exit(1);
		}
        close(pipe_fd1[0]);
        close(pipe_fd2[0]);
        write(pipe_fd2[1],"Child process p2 is sending a message!",38);//向管道中发送字符串
        close(pipe_fd2[1]);        
        exit(0);
	}
	
    //父进程
	else{
		printf("I am main process, PID = %d\n",getpid());       //声明，打印进程号
		exit(0);
	}
}


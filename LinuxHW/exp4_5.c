#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

int Fibo[100];  //Fibonacci数组  
pthread_t tid;  //子线程
		
//Fibonacci函数，递归
int fibonacci(int n){
    if(n==0) return 0;
    else if(n==1) return 1;
    else
        return fibonacci(n-2)+fibonacci(n-1);
}

//产生Fibonacci序列，放入共享数组中
void *create_fibonacci(void *num)
{
	int n = (int)num;
	while(n>=1){
		Fibo[n-1] = fibonacci(n-1);
		n--;
	}
}

int main(int argc,char* argv[])
{
	int err;
	int num = atoi(argv[1]);    //参数为Fibonacci序列个数
	int j;
    
    //创建线程，若失败则返回
	err = pthread_create(&tid,NULL,create_fibonacci,(void*)num);
	if(err != 0){
		printf("Cannot create pthread!");
		exit(1);
	}
    
    //线程结束打印声明
	if(tid != 0){
		pthread_join(tid,NULL);
		printf("Pthread finished.");
	}

    //输出Fibonacci序列
	printf("Fibonacci sequence is:\n");
	for(j=0;j<num;j++)
		printf("%d ",Fibo[j]);
	printf("\n");
	return 0;
}

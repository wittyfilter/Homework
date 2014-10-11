swap()  
{  
    #交换数组的两个元素  
    local temp=${integer[$1]}  
    integer[$1]=${integer[$2]}  
    integer[$2]=$temp  
    return   
}  
#读入一串整数
echo "Please enter some integers:"
read -a integer
#得到整数个数
n=${#integer[@]} 
echo "There are $n integers."
#冒泡排序
for ((i=n-1;i>0;i--))     
do   
	for ((j=0;j<i;j++))     
	do  
		a=${integer[$j]}  
		b=${integer[$((j+1))]}    
		if [ "$a" -gt "$b" ]
		then  
			swap $j $((j+1))  
		fi  
	done  
done
#输出排序后数组、最小值、最大值以及总和
echo "Sorted integers are:"
echo "${integer[@]}"
echo "The smallest one is ${integer[0]}."
echo "The biggest one is ${integer[$((n-1))]}."
sum=0
for ((i=0;i<n;i++))
do
	sum=$((sum+integer[$i]))
done
echo "The sum of the integers are $sum."    
exit 0

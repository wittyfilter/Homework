#如果无输入则提示
if [ -z $1 ]
then
	echo "USAGE: ./exp4_1.sh filename"
	exit 1 
#如果输入超过一个参数报错
elif [ $# -gt 1 ]
then
	echo "Wrong! No more than one parameter!"
	exit 1
#判断输入参数是否为文件
elif [ -f $1 ]
then
	echo "$1 is a file."
    username=$(ls -l $1 | awk '{print $3}')
	changetime=$(ls -l $1 --full-time | awk '{print $6}')
	echo "Owner：$username"		#打印所有者和最后修改日期
	echo "Last changed time：$changetime"
else #否则输出：非文件
	echo "$1 is not a file."
fi
exit 0
	 


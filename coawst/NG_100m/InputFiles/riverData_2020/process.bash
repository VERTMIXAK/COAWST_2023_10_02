for files in `ls data_ORIG`
do

	file=`echo $files | cut -d '.' -f1`
	grep USGS data_ORIG/$file.txt | grep -v '#' | sed 's/\t/,/g' > dum.txt
	\rm $file"*.txt"
	{
	while read line
	do
	#    echo $line
		date=`echo $line | cut -d ',' -f3`
		flowORIG=`echo $line | cut -d ',' -f4`
		dayN=`grep $date ~/addl_Scripts/dayConverterCommas.txt | cut -d ',' -f2`".5"

		flow=` echo "scale=2; $flowORIG * 1000. / 35.315 " | bc `
	#	echo $date $dayN $flow
		echo $dayN $flow 
	done < dum.txt
	} > $file"_dailyAve.txt"
	\rm dum.txt

done


# Sum Quinebaug, Yantic and Shetucket to get the Thames River
#file1="Quinebaug_dailyAve.txt"
#file2="Yantic_dailyAve.txt"
#file3="Shetucket_dailyAve.txt"
#{
#ii=0
#while read line
#do	
#	ii=`echo " $ii + 1 " | bc `
#	date=`echo $line | cut -c 1-7`
#	var1=`echo $line                 | cut -c 8-20`
#	var2=`head -$ii $file2 | tail -1 | cut -c 8-20`
#    var3=`head -$ii $file3 | tail -1 | cut -c 8-20`
#	sum=`echo " $var1 + $var2 + $var3 " |bc`
#	echo $ii $date $var1 $var2 $var3 $sum
#    echo $date $sum
#done < $file1
#} > Thames_dailyAve.txt
#\rm $file1
#\rm $file2
#\rm $file3


# Sum Moshassuck, Woonasquatucket, Blackstone and Ten Mile to get the Providence River
file1="Moshassuck_dailyAve.txt"
file2="Woonasquatucket_dailyAve.txt"
file3="Blackstone_dailyAve.txt"
file4="TenMile_dailyAve.txt"
{
ii=0
while read line
do
    ii=`echo " $ii + 1 " | bc `
    date=`echo $line | cut -c 1-7`
    var1=`echo $line                 | cut -c 8-20`
    var2=`head -$ii $file2 | tail -1 | cut -c 8-20`
    var3=`head -$ii $file3 | tail -1 | cut -c 8-20`
    var4=`head -$ii $file4 | tail -1 | cut -c 8-20`
    sum=`echo " $var1 + $var2 + $var3 + $var4" |bc`
#   echo $ii $date $var1 $var2 $var3 $var4 $sum
    echo $date $sum
done < $file1
} > Providence_dailyAve.txt

\rm $file1
\rm $file2
\rm $file3
\rm $file4

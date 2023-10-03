##grep USGS | grep ':00' data_ORIG/temp2_Taunton.txt_ORIG | cut -d ',' -f3 | cut -d ' ' -f1 > dates2.txt
##grep USGS | grep ':00' data_ORIG/temp2_Taunton.txt_ORIG | cut -d ',' -f3 | cut -d ' ' -f2 | cut -d ':' -f1 > hours2.txt
##grep USGS | grep ':00' data_ORIG/temp2_Taunton.txt_ORIG | cut -d ',' -f5 > temps2.txt


#grep 'USGS,' | grep ':00' Tdata_ORIG/temp2_Taunton.txt_ORIG > dum2.txt



\rm tempDayN2.txt

while read line
do
#	echo $line
	date=`echo $line | cut -c 15-24`
	grep $date /import/home/jgpender/addl_Scripts/dayConverterCommas.txt | cut -d ',' -f2 >> tempDayN2.txt

	echo $line | cut -c 26-27 >> tempHour2.txt
	echo $line | cut -d ',' -f5 >> temp2.txt
done < dum2.txt



exit
















echo "start"


while read temp
do
	echo "ha"
	echo $temp$temp
	dum=`grep $date /import/home/jgpender/addl_Scripts/dayConverterCommas.txt | cut -d ',' -f2`
	echo $dum
done < dates.txt





exit


\rm timeStampT.txt

ii=1
while read day
do
	ii=`echo "$ii + 1" | bc`

echo $day
#	dayN=`grep $day ~/addl_Scripts/dayConverterCommas.txt | cut -d ',' -f2`

exit

#	dayN=`grep $day ~/addl_Scripts/dayConverterCommas.txt | cut -d ',' -f2`
	hour=`head -$ii hours.txt | tail -1`

echo $hour

#	hourN=`echo "scale=3; $hour / 24" | bc`
#	timeStamp=`echo "scale=3; $dayN + $hourN " | bc`
#	echo $ii $dayN $hour 
##	echo $ii $timeStamp
#	echo $timeStamp 

done < days.txt

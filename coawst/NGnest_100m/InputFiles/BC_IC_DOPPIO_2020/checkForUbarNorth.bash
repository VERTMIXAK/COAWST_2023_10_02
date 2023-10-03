for file in `ls scheduleForDeletion `
do
	echo $file
	ncdump -h scheduleForDeletion/$file | grep ubar_north
done

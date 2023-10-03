

#!!!!!!!!!! Double check typical size
sizeTarget="120K"

archiveDir='/import/VERTMIX/NORSE2023_SA/GFS_surface_forcing/'
for file in `ls G*.nc`
do
    size=`\ls -lh $file | cut -c 31-34`
    echo $size
    if [[ "$size" == "$sizeTarget" ]]
    then
        echo "strings are equal"
        mv $file $archiveDir
    else
        echo "file size is wrong"
    fi
done

#\rm out* GFS*ORIG *.tmp *.nc





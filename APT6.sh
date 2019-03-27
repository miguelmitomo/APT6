read -p "Introduce el nombre del archivo: " file
while [ ! -r $file ]; do
    read -p "Error. El archivo no existe o no tiene permisos de lectura, vuelve a introducir otro nombre: " file
done
numUsers=0
numGroups=0
line=1
group=''
lastMaxNumUsers=0
maxGroups=''
for i in $(cat $file | awk '{print $1}'); do
    numGroups=$((numGroups + 1))
done
echo "En el fichero proporcionado tenemos $numGroups grupos:"
while [ $line -le $numGroups ]; do
    j=`cat $file | head -${line} | tail -1`
    group=`echo $j | awk '{print $1}'`
    group=${group/:/}
    numUsers=`echo $j | awk '{print NF}'`
    numUsers=$(($numUsers-1))
    if [ $line -eq 1 ]; then
	lastmaxNumUsers=$numUsers
	maxGroups=$group
    else
	    if [ $numUsers -eq $lastMaxNumUsers ]; then
	        maxGroups="$maxGroups $group"
	        lastMaxNumUsers=$numUsers
	    elif [ $numUsers -gt $lastMaxNumUsers ]; then
	        maxGroups=$group
	        lastMaxNumUsers=$numUsers
	    fi
    fi     
    line=$((line+1))
    echo "$group: $numUsers usuarios"
done
echo "El/Los grupo/s que tiene/n más usuarios es/son $maxGroups"

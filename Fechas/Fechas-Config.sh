#!/bin/bash

CambiarFecha() {

day=$(date --file=$ruta/Fecha1.txt +%x | cut -d "/" -f 1)
month=$(date --file=$ruta/Fecha1.txt +%x | cut -d "/" -f 2)
year=$(date --file=$ruta/Fecha1.txt +%x | cut -d "/" -f 3)

Fecha=$(dialog --calendar "Fecha inicio" 0 0 $day $month $year 3>&1 1>&2 2>&3)
clear
if [ $Fecha != null ]; then

	day=$(echo $Fecha | cut -d "/" -f 1)
	month=$(echo $Fecha | cut -d "/" -f 2)
	year=$(echo $Fecha | cut -d "/" -f 3)

	Fecha="$year$month$day"
else 
	Fecha="error"
fi
}

ruta=`dirname $0`;

SCRIPT=$(readlink -f $0)
dir=`dirname $SCRIPT`
dir=`dirname $dir`

CambiarFecha

if [ "$Fecha" != "error" ];then

	FechaDeHoy=$(date +"%Y%m%d")

	while [ $Fecha -lt $FechaDeHoy ]; do
		dialog --msgbox "Debes introducir una fecha válida" 0 0
		CambiarFecha
	done
	Fecha="$month/$day/$year"
	date --date="$Fecha" +"%m/%d/%y" > $ruta/Fecha1.txt
	crontab -r
	dir="$dir/Fechas/Trigger.sh"
	echo $dir
	read X
	echo "* * $day $month * bash $dir" >> /var/spool/cron/crontabs/root
	A=$(date --file=$ruta/Fecha1.txt +%x)
	dialog --infobox "Próxima ejecucion: $A" 0 0
	sleep 2


else
	echo "255"  > $ruta/../salida.txt && clear && exit
fi



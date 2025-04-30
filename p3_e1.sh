#!/bin/bash
# Propòsit: Fer una còpia de segurtat d'una base de dades MySQL,
#	comprimir-la i guardar-la en un directori específic.

# 0. Comprovem si rebem els paràmetres
if [ $# -ne 5 ]; then
	echo "[ERROR]: El nombre de paràmetres hauria de ser 5, però és $#"
	echo "Ús: ./backupBD.sh usuari password host base_de_dades desti"
	exit 1
fi

# 1. Preparem les variables rebudes per paràmetre

# -> Assignem les variables
usuari=$1
contrasenya=$2
host=$3
baseDeDades=$4
directoriDesti=$5
data=$(date +"%Y%m%d%h%M")

if [ ! -d $directoriDesti ]; then
	echo "[ERROR]: La ruta ${directoriDesti} no existeix"
	exit 1
fi

# 2. Fem la còpia de seguretat amb mysqldump
fitxerBackup=${baseDeDades}_$data
if ! mysqldump -u $usuari -p$contrasenya -h $host $baseDeDades > $fitxerBackup; then
	echo "Executant: mysqldump -u $usuari -p$contrasenya -h $host $baseDeDades > $directoriDesti"
	echo "[ERROR] Error en fer la còpia de seguretat de la base de dades ${baseDeDades}"
	exit 1
fi

# 3. Comprimim la còpia de seguretat amb gzip
fitxerComprimit="${fitxerBackup}.gz"
if ! gzip $fitxerComprimit; then
	echo "[ERROR] Error en comprimir el fitxer ${fitxerComprimit}"
	exit 1
fi


# 4. Movem la còpia de seguretat comprimida al directori de destí amb mv
if ! mv $fitxerComprimit $directoriDesti; then
	echo "[ERROR] Error en moure ${fitxerComprimit} a ${directoriDesti}"
	exit 1
fi

echo "[INFO] Còpia de seguretat de la bases de dades '${baseDeDades}' creada i guardada a ${directoriDesti}/${fitxerComprimit}"

exit 0

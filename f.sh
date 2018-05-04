function checkDirChap() {
	dir=$1
	dir2=$dir
	if [ $dir -lt 10 ]; then
		dir2="00$dir"
	else
		if [ $dir -lt 100 ]; then
			dir2="0$dir"
		fi
	fi
	
	if [ ! -d "$dir2" ]; then
		mkdir $dir2
	else
		echo "dir $dir2 già esistente"
	fi
	
	cd $dir2
}

function checkDir() {
	dir2=$1
	if [ ! -d "$dir2" ]; then
		mkdir $dir2
	else
		echo "dir $dir2 già esistente"
	fi
}

function usage() {
	echo "Usage: $0 [MANGA] [en o it]";
	echo "";
	echo "MANGA é il nome del manga (es: sailor-moon)"
	echo "";
	exit 1;
}

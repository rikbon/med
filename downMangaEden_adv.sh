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


WGET="$(which wgetd) -q"
if [ "$WGET" = " -q" ]; then
	echo "wget is missing. Cannot continue"
	exit 1
fi

#ZIP="$(which zip)"
CAPITOLI=$1_capitoli.txt
CAPITOLI_TMP=$1_capitoli.txt.tmp

baseDir=`echo $PWD`
if [ $# -eq 0 ]; then
	usage
fi

echo "DOWNLOAD MANAGER PER MANGAEDEN"
echo "##############################"
echo "In download: $1"
echo "##############################"

checkDir $1
cd $1

resChap=0
resImg=0

if [ ! -f "$1.resume" ]; then
	echo "Riparto da zero"
	rm -rf ./*
	resChap=0
	resImg=0
else
	resChap=$(cat $1.resume | awk '{print $1}')
	resImg=$(cat $1.resume | awk '{print $2}')
fi
	
downLink="https://www.mangaeden.com/it/$2-manga/$1"
echo $downLink

$WGET -O $1.txt $downLink/1/1/

cat $1.txt | grep -v "$1/1/" | grep "<option" | sed -e "s|<option|\n<option|g" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' > $CAPITOLI_TMP
sed -e '/^\s*$/d' $CAPITOLI_TMP | sort -n > $CAPITOLI
capitoli=$(tail -1 $CAPITOLI)
rm $CAPITOLI_TMP
cat $CAPITOLI | while read cap
do
	num=$cap
	if [ $cap -lt $resChap ]; then
		echo "CAPITOLO $cap SALTATO"
	else
		echo "CAPITOLO: $num di $capitoli"
		checkDirChap "$num"
		$WGET -O file.txt $downLink/$num/1
		cat file.txt | grep "$1/$num/" | grep "<option" | sed -e "s|<option|\n<option|g" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' | sed '/^\s*$/d' > $num.txt
		pagine=$(wc -l $num.txt)
		echo "Numero pagine: $pagine"
		rm file.txt
#		img=$resImg
		cat $num.txt | while read j
		do
#			echo "AAAAAA: $resImg"
#			if [ $j -lt $img ]; then
#				echo "CAPITOLO $cap IMMAGINE $j SALTATA"
#			else
				pag=$(printf "%05d" $j)
				echo "Scaricando CAPITOLO $num di $capitoli - PAGINA $j di $pagine"
				$WGET -O $pag.txt "$downLink/$num/$j"
				lin=$(cat $pag.txt | grep -i "Manga $(echo $1|sed -e 's/-/ /g') " | awk -F"src" '{print $2}' | awk -F\" '{print $2}' | awk '{print $1}')
				$WGET -O $pag.jpg "http:$lin"
				rm $pag.txt
				echo "$num $j" > ../$1.resume
#				img=0
#			fi

		done
		rm $num.txt
		cd ..
	fi
done
rm *.txt

MANGANAME=$1
source /home/ricca/git/med/med.properties ##### MODIFY PATH ACCORDING TO YOUR NEEDS
source $baseDir/f.sh

WGET="$(which wget) -q"
if [ "$WGET" = " -q" ]; then
	echo "wget is missing. Cannot continue"
	exit 1
fi

#ZIP="$(which zip)"
CAPITOLI=$MANGANAME_capitoli.txt
CAPITOLI_TMP=$MANGANAME_capitoli.txt.tmp

if [ $# -eq 0 ]; then
	usage
fi

echo "DOWNLOAD MANAGER PER MANGAEDEN"
echo "##############################"
echo "In download: $MANGANAME"
echo "##############################"

dirManga=$currDir/$MANGANAME
checkDir $dirManga
cd $dirManga

resChap=0
resImg=0

if [ ! -f "$MANGANAME.resume" ]; then
	echo "Riparto da zero"
	rm -rf $dirManga/*
	resChap=0
	resImg=0
else
	resChap=$(cat $MANGANAME.resume | awk '{print $1}')
	resImg=$(cat $MANGANAME.resume | awk '{print $2}')
fi
	
downLink="https://www.mangaeden.com/it/$2-manga/$MANGANAME"
echo $downLink

$WGET -O $MANGANAME.txt $downLink/1/1/

cat $MANGANAME.txt | grep -v "$MANGANAME/1/" | grep "<option" | sed -e "s|<option|\n<option|g" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' > $CAPITOLI_TMP
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
		cat file.txt | grep "$MANGANAME/$num/" | grep "<option" | sed -e "s|<option|\n<option|g" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' | sed '/^\s*$/d' > $num.txt
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
				lin=$(cat $pag.txt | grep -i "Manga $(echo $MANGANAME|sed -e 's/-/ /g') " | awk -F"src" '{print $2}' | awk -F\" '{print $2}' | awk '{print $1}')
				$WGET -O $pag.jpg "http:$lin"
				rm $pag.txt
				echo "$num $j" > ../$MANGANAME.resume
#				img=0
#			fi

		done
		rm $num.txt
		cd ..
	fi
done
rm *.txt

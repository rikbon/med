## med
Bash script that helps to automatically download from [MangaEden](https://www.mangaeden.com/)

At the moment the scripts outputs in Italian.
Internationalization coming in the next versions.

Usage:
<br>downMangaEden_adv.sh [MANGA_NAME] [LANG]

MANGA_NAME is the name contained in the url of the manga (for instance, having an url like https://www.mangaeden.com/it/it-manga/one-piece/, MANGA_NAME is **_one-piece_** 

LANG is the language version of the manga. Accepted values are *it* o *en* 

## REQUIREMENTS
<br>Obviously, the script must be run in a bash environment, will it be a linux box, Cygwin, mintty, Windows Linux Subsystem and so on.
Having **wget** installed is *mandatory*

## TO AFTER DOWNLOAD
Modify files
 * *med.properties*, changing absolute path of variable baseDir
 * *downMangaEden_adv.sh*  changing absolute path at line #2


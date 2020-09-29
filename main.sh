#!/bin/bash

echo "iniciou em `date +%F-%T`"

apppath="/usr/local/hardmob"

config_file="config.sh"

if [ ! -f "$apppath/$config_file" ]
then
	echo "faltou o arquivo de configuracao $config_file"
	exit 1
else
	. "$apppath/$config_file"
fi

keywords="keywords.txt"

if [ ! -f "$apppath/$keywords" ]
then
	echo "faltou o arquivo $keywords"
	exit 2
fi

hardmoburl="https://www.hardmob.com.br/forums/407-Promocoes"
mainurl="https://www.hardmob.com.br"
urlfile="$apppath/urls.txt"
md5urlfile="$apppath/md5-urls.txt"
threadfile="$apppath/threads.txt"
mailfile="$apppath/email.txt"
excludefile="$apppath/exclude.txt"
[[ -f $mailfile ]] && rm -f $mailfile

regexon="`$apppath/build_regex.sh`"
regexoff="`$apppath/build_regex.sh off`"

curl $socks -k "$hardmoburl" 2> /dev/null | egrep -i "$regexon" | egrep -iv $regexoff | grep -P 'href="(.*?)"' -o | cut -d" " -f1 | cut -d"=" -f2- | tr -d "\"" | sort | uniq | while read url
do
	if [ ! $(echo "$url" | fgrep "$mainurl" -o > /dev/null 2>&1 ; echo $?) = 0 ]
	then
		exclude="1"
		for ex_url in `cat $excludefile`
		do
			echo -e "URL:\t\t\t$url"
			exclude="$(echo $url | fgrep $ex_url > /dev/null 2>&1;echo $?)"
			if [ $exclude = 0 ]
			then
				echo -e "URL excluída:\t\t$ex_url"
				break
			fi
		done
		if [ $exclude = 1 ]
		then
			promourl="$mainurl/$url"
			thread=`echo "$promourl" | grep -P "https://www.hardmob.com.br/threads/([0-9]+).*?" -o | cut -d "/" -f5`
			md5url=`echo $promourl | md5sum -t 2> /dev/null | tr -s " " | cut -d "-" -f1`
			#retval="$(fgrep $md5url $md5urlfile > /dev/null 2>&1 ; echo $?)"
			retval="$(fgrep $thread $threadfile > /dev/null 2>&1 ; echo $?)"
			if [ ! "$retval" = "0" ]
			then
				echo -e "Nova url encontrada\t$promourl"
				echo $promourl >> $urlfile
				echo $promourl >> $mailfile
				echo $md5url >> $md5urlfile
				echo $thread >> $threadfile
			else
				echo -e "URL já existente:\t$promourl"
			fi
		fi
	fi		
done

# se vc tem um script par enviar e-mails, coloque aí embaixo
mailscript="$apppath/sendmail.py"
if [ -f $mailfile -a -f $mailscript -a ! -z $maildest ]
then
	echo "enviando e-mail..."
	/usr/bin/python $mailscript $maildest "Novas URLs encontradas!" $mailfile
fi


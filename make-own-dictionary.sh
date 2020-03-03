#!/bin/bash
mkdir mp3
mkdir json
> words.txt

# curl -o /dev/null -s -w "%{http_code}\n" https://howjsay.com/mp3/$word.mp3 
# echo $json  | jq .results[0].definition
# echo $json  | jq .word == 
# http://translate.google.com/translate_tts?ie=UTF-8&total=1&idx=0&textlen=32&client=tw-ob&q=$word&tl=en

# TODO for using phrases, not only words - update urls (urlencode) and get info from another websites


cat list.txt|while read line
  do
    read -d, word < <(echo $line)
    echo "------- $word -------"

    if [ -f "mp3/$word.mp3" ]; then
        echo "mp3 + " #exist, skipped"
    else 
        echo "mp3 - " #does not exist"
        howjsay_http_status=`curl -o /dev/null -s -w "%{http_code}\n" https://howjsay.com/mp3/$word.mp3`
        if [[ "$howjsay_http_status" == "404"* ]]; then
            echo "audio google tts"
            curl "http://translate.google.com/translate_tts?ie=UTF-8&total=1&idx=0&textlen=32&client=tw-ob&q=$word&tl=en" -H 'User-Agent: Mozilla/5.0' --silent > "mp3/$word.mp3"
        else
            echo "audio howjsay"
            curl "https://howjsay.com/mp3/$word.mp3" --silent > "mp3/$word.mp3"
        fi
    fi

    if [ -f "json/$word.json" ]; then
        echo "json + " #exist, downloading skipped"
        json=`cat json/$word.json`
        definition=`echo $json | jq --raw-output '.results[0].definition'`
    else 
        echo "json - " #does not exist, downloading"
        json=`curl "https://www.wordsapi.com/mashape/words/$word?when=2020-02-11T09:28:09.276Z&encrypted=8cfdb18ae722919beb9007bfe658bcb1aeb0240932f891b8" -H 'authority: www.wordsapi.com' -H 'accept-encoding: gzip' -H 'cookie: __cfduid=ded8b456b89f8d2567c4ea018ea9ffdca1581412155' --compressed  --silent`
        echo $json > json/$word.json
        definition=`echo $json | jq --raw-output '.results[0].definition'`
    fi

    echo $definition
    echo -e "$word\t$definition" >> words.txt

  done
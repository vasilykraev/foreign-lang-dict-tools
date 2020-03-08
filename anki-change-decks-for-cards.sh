#!/bin/bash

# Moving special selected words from big dictionary to personal deck by using AnkiConnect
# Full documenation you can find at https://foosoft.net/projects/anki-connect/index.html

big_deck="14000"
my_deck="my-deck"

cat list.txt|while read line
  do
    read -d, word < <(echo $line)
    echo "------- $word -------"
    
    json="{\"action\": \"findCards\", \"params\": { \"query\": \"$bigdeck english:$word\" }}"
    cards=`curl localhost:8765 -X POST -d "$json" --silent`
    echo $cards
    json_change_deck="{\"action\": \"changeDeck\", \"params\": { \"cards\": $cards, \"deck\": \"my-words\" }}"
    echo $json_change_deck
    result=`curl localhost:8765 -X POST -d "$json_change_deck" --silent`
    
  done
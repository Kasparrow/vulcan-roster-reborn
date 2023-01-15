#!/bin/bash
#
if [[ -d ./tmp ]]; then
        rm -rf ./tmp
fi

mkdir tmp tmp/img tmp/character
cp -rf src/css tmp/css
cp -rf src/fonts tmp/fonts

while read player; do
        character=`echo $player | awk -F "," '{ print $1 }'`
        realm=`echo $player | awk -F "," '{ print $2 }'`
        role=`echo $player | awk -F "," '{ print $3 }'`

        cp "./data/$realm/$character/avatar.jpg" "./tmp/img/$character-$realm.jpg"

        class=`cat ./data/$realm/$character/character | jq .character_class.name | sed "s~\"~~g"`
        class_id=`cat ./data/$realm/$character/character | jq .character_class.id | sed "s~\"~~g"`
        ilvl=`cat ./data/$realm/$character/character | jq .equipped_item_level | sed "s~\"~~g"`
        title=`cat ./data/$realm/$character/character | jq .active_title.display_string | sed "s~\"~~g;s~null~~"`

        if [ -z "$title" ]; then
                title=$character
        fi

        cat src/templates/character_entry.html |
                sed "s~URL~./img/$character-$realm.jpg~" |
                sed "s~NAME~$title~" |
                sed "s~{name}~$character~" |
                sed "s~CLASS_ID~$class_id~" |
                sed "s~CLASS~$class~" |
                sed "s~ILVL~$ilvl~" |
                sed "s~ROLE~$role~" >> ./tmp/roster

done < <(tail -n +2 ./config/players.csv | grep -E '^[a-z]')

cat src/templates/index.html | sed "s~ROSTER~$(cat ./tmp/roster | tr -d '\n')~" > ./tmp/index.html
cp src/img/header.jpg tmp/img/header.jpg

if [[ -d ./release ]]; then
        rm -rf ./release
fi

mv tmp release

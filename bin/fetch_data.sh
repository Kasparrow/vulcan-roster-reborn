#!/bin/bash

source config/secrets.sh

BLIZZARD_HOST=https://eu.api.blizzard.com
CHARACTER_PATH=/profile/wow/character
NAMESPACE=profile-eu
LOCALE=fr_FR

access_token=`curl -u $CLIENT_ID:$CLIENT_SECRET -d grant_type=client_credentials https://oauth.battle.net/token | jq .access_token | sed "s~\"~~g"`

if [[ -d ./tmp ]]; then
        rm -rf ./tmp
fi

mkdir tmp

while read player; do
        character=`echo $player | awk -F "," '{ print $1 }'`
        realm=`echo $player | awk -F "," '{ print $2 }'`
        role=`echo $player | awk -F "," '{ print $3 }'`

        if [[ ! -d ./tmp/$realm ]]; then
                mkdir "./tmp/$realm"
        fi

        mkdir "./tmp/$realm/$character"

        # CHARACTER SUMMARY
        curl --header "Authorization: Bearer $access_token" \
                "$BLIZZARD_HOST$CHARACTER_PATH/$realm/$character?namespace=$NAMESPACE&locale=$LOCALE" > ./tmp/$realm/$character/character


        # EQUIPMENT
        curl --header "Authorization: Bearer $access_token" \
                "$BLIZZARD_HOST$CHARACTER_PATH/$realm/$character/equipment?namespace=$NAMESPACE&locale=$LOCALE" > ./tmp/$realm/$character/equipment

        # JOBS
        curl --header "Authorization: Bearer $access_token" \
                "$BLIZZARD_HOST$CHARACTER_PATH/$realm/$character/professions?namespace=$NAMESPACE&locale=$LOCALE" > "./tmp/$realm/$character/jobs"

        # PROGRESS
        # raider io doesn't handle accent in realm character
        character_slug=`./bin/slug.sh $character`
        realm_slug=`./bin/slug.sh $realm`
        curl -X 'GET' \
  "https://raider.io/api/v1/characters/profile?region=eu&realm=$realm_slug&name=$character_slug&fields=mythic_plus_best_runs,raid_progression" -H "accept: application/json" > ./tmp/$realm/$character/progress

        # AVATAR
        avatar_url=`curl --header "Authorization: Bearer $access_token" \
                "$BLIZZARD_HOST$CHARACTER_PATH/$realm/$character/character-media?namespace=$NAMESPACE&locale=$LOCALE" \
                > tmp_urls`
        avatar_img_url=`cat tmp_urls | jq ".assets | map(select(.key == \"avatar\")) | .[0].value" | sed s/\"//g`
        main_raw_img_url=`cat tmp_urls | jq ".assets | map(select(.key == \"main-raw\")) | .[0].value" | sed s/\"//g`

        curl $avatar_img_url -o "./tmp/$realm/$character/avatar.jpg"
        curl $main_raw_img_url -o "./tmp/$realm/$character/main-raw.jpg"

        
done < <(tail -n +2 ./config/players.csv | grep -E '^[a-z]')

rm tmp_urls

if [[ -d ./data ]]; then
        rm -rf ./data
fi


mv tmp data

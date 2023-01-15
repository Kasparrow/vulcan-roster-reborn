# vulcan-roster-reborn

This project is a (WIP) alternative version to [vulcan-roster](https://github.com/grahamliphts/vulcan-roster/tree/2ba1ca7bd54ec3745731e97b2942d9a8b6965b28).

The goal of this project is to use the Blizzard API to build a static website for a WoW guild.

## Install

1. Clone the project
2. Edit `config/players.csv` so it contains the members of your guild
3. Rename `secrets.sh.example` to `secrets.sh` and replace placeholders in the file with your credentials
4. Run `./bin/make.sh` to generate the website

## Update data

Unlike [vulcan-roster](https://github.com/grahamliphts/vulcan-roster/tree/2ba1ca7bd54ec3745731e97b2942d9a8b6965b28), the data of the players are not
updated on each reload of the page. It is designed to be rebuild automatically every 5 minutes with a cron job (if needed).

## Demo 

[Hosted](https://kasparrow.github.io/vulcan-roster-reborn/) on github pages for the moment, I'll host it later when all the features will be finished to try the automatic rebuild.

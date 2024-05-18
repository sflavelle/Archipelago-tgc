#!/bin/bash

function get_git_release {
	url=$(curl -s https://api.github.com/repos/$2/releases/latest | grep "browser_download_url.*" | grep apworld | fzf -1 -0 | cut -d : -f 2,3 | tr -d \"[:space:])
	eval "$1=`[ -z $url ] && echo $ver || echo $url`"
}

function update_from_git {
	get_git_release url $1
	http -d -o "$2.apworld" $url || echo Failed download. Url used: $url
}

function update_prompt {
	# params: name, github-slug, filename
	read -r -p "Update $1? [y/N]" REPLY
	case "$REPLY" in
		y|Y ) update_from_git $2 $3;;
		* ) echo "Not updating.";;
	esac
}

pushd /srv/Archipelago/worlds/

# update Banjo-Tooie
update_prompt "Banjo-Tooie" "jjjj12212/Archipelago-BanjoTooie" banjo_tooie

# update A Hat in Time
update_prompt "A Hat in Time" "CookieCat45/Archipelago-ahit" ahit 

# update ULTRAKILL
update_prompt ULTRAKILL "TRPG0/ArchipelagoULTRAKILL" ultrakill

# update Ape Escape
update_prompt "Ape Escape" "CDRomatron/Archipelago-Ape-Escape" apeescape

# update Hades
update_prompt Hades "NaixGames/Polycosmos" hades

# update Celeste
update_prompt Celeste "doshyw/CelesteArchipelago" celeste

# update Bindign of Isaac Repentance
update_prompt "The Binding of Isaac: Repentance" "Cyb3RGER/TBoI-AP-Mod" tboir

# update Bloons TD6
update_prompt "Bloons Tower Defense 6" "GamingInfinite/Archipelago" bloonstd6

# update KH1FM
update_prompt "Kingdom Hearts 1: Final Mix" "gaithernOrg/KH1FM-AP" kh1

# update Outer Wilds
update_prompt "Outer Wilds" "Ixrec/OuterWildsArchipelagoRandomizer" outer_wilds

# update MLSS
update_prompt "Mario & Luigi: Superstar Saga" "jamesbrq/ArchipelagoMLSS" mlss

# update Rabi-Ribi
update_prompt "Rabi-Ribi" "tdkollins/Archipelago-Rabi-Ribi" rabi_ribi

# update osu!
update_prompt "osu" "lilymnky-F/Archipelago-Osu" osu

# update The Guardian Legend
update_prompt "The Guardian Legend" "CoreZer0/TheGuardianLegend-AP" guardianlegend

# update Duke 3D
update_prompt "Duke Nukem 3D" "LLCoolDave/Duke3DAP" duke3d

# update Yooka Laylee
update_prompt "Yooka Laylee" "Awareqwx/Archipelago" yooka_laylee

# update CrossCode
update_prompt "CrossCode" "CodeTriangle/CCMultiworldRandomizer" crosscode

# update Paper Mario
update_prompt "Paper Mario" "JKBSunshine/PMR_APWorld" papermario

# update FFTA
update_prompt "Final Fantasy Tactics Advance" "spicynun/Archipelago" ffta

# update Risk of Rain
update_prompt "Risk of Rain" "studkid/RoR_Archipelago" ror1

# update OpenRCT2
read -p "Update OpenRCT2? " ver_rct2
[ -n "$ver_rct2" ] && pushd /srv/APBranches/OpenRCT2 && git pull && popd

# update WarioLand4
read -p "Update Wario Land 4? " ver_wl4
[ -n "$ver_wl4" ] && pushd /srv/APBranches/WarioLand4 && git pull && popd

# Restart the AP Host when done
read -p "Reboot rando.thegeneral.chat? (y/n) " reboot
[ "$reboot" = "y" ] && echo "Rebooting rando.thegeneral.chat!" && pm2 restart APHost || echo "Reboot later with 'pm2 restart APHost'"

echo "All done."
popd

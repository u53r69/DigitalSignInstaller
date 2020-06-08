function chooseLector(){ # Funzione per scegliere il proprio lettore
    zenity --title="DSInstaller" --list --text="Scegli il tuo lettore" --column="Nome" --column="Marca"\
    "miniLector POCKET" "Bit4id"\
    "miniLector EVO"    "Bit4id"\
    "miniLector S EVO"  "Bit4id"\
    "miniLector Piano"  "Bit4id"\
    "miniLector Spaceship"  "Bit4id"\
    --height="300" --width="250"
}
function chooseCard() {
  zenity --title="DSInstaller" --list --text="Scegli la tua card" --column="Nome"\
  "Incard"\
  "Athena"\
  "Oberthur"\
  --height="300" --width="250"
}
function chooseOS() { # Funzione per indicare il proprio sistema operativo
  zenity --title="DSInstaller" --list --text="Scegli il tuo sistema operativo" --column="Distro" --column="Formato Pacchetti"\
  "Debian, Ubuntu, Linux Mint"  ".deb"\
  "Fedora, Red Hat, CentOS"    ".rpm"\
  --height="300" --width="250"
}

function dirError() { # Funzione per la visualizzazione del messaggio di errore nella creazione della directory di lavoro
  zenity --title="DSInstaller" --error --text="Errore nella creazione della directory $1 . Assicurarsi di avere i permessi necessari." --width="400" --height="200"
  exit 1
}

function downloadError() { # Funzione per la visualizzazione del messaggio di errore nel download dei driver
  zenity --title="DSInstaller" --error --text="Errore nel download dei drivers. Assicurarsi di avere i permessi necessari ed essere connessi ad Internet." --width="400" --height="200"
  exit 1
}

#! /bin/bash

################## COSE DA FARE (02/03/2020) ##################
# * Snellimento generale
# * Ottimizzare le funzioni (scriverle con meno righe, rendere tutto più leggibile)
# * Progettare nei dettagli l'algoritmo
# * Aggiungere barra progressiva nel download (PROBLEMATICO)
# * Migliorare controllo errori
# * Modularizzare maggiormente il codice
# * Trovare un modo sicuro di gestire l'immissione della password
# * Capire come individuare i file da installare in modo intelligente
###############################################################

############# FUNZIONI ##############

function chooseLector(){ # Funzione per scegliere il proprio lettore
    zenity --title="DSInstaller" --list --text="Scegli il tuo lettore" --column="Nome" --column="Marca"\
    "ArubaKey"  "Aruba"\
    "miniLector POCKET" "Bit4id"\
    "miniLector EVO"    "Bit4id"\
    "miniLector S EVO"  "Bit4id"\
    "miniLector Piano"  "Bit4id"\
    "miniLector Spaceship"  "Bit4id"\
    --height="300" --width="250"
}

function chooseOS() { # Funzione per indicare il proprio sistema operativo
  zenity --title="DSInstaller" --list --text="Scegli il tuo lettore" --column="Distro" --column="Formato Pacchetti"\
  "CentOS"  ".rpm"\
  "Debian" ".deb"\
  "Fedora"    ".rpm"\
  "Linux Mint"  ".deb"\
  "Red Hat"  ".rpm"\
  "Ubuntu"  ".deb"\
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
#####################################

Z_VERSION=$(zenity --version) #Controllo che Zenity sia installato
if [[ -z $Z_VERSION ]] # Se la variabile $Z_VERSION è vuota, significa che Zenity non è stato installato
then
  echo "Non hai installato Zenity sul tuo PC. Per sapere come procedere, visita la pagina di aiuto. "
  exit 1; # Esco con un errore
else
  zenity  --title="DSInstaller" --info --text="Benvenuto nella procedura guidata di installazione dei driver per la firma digitale.\n Clicca <a href=\"https://www.google.it\">qui</a> per sapere qual'è il tuo lettore" --width="400" --height="200" # Messaggio di benvenuto e link per info su scelta del lettore

  OS=$(chooseOS) # Selezione OS
  if [[ -z $OS ]]; then # Se l'utente ha premuto "ANNULLA", il programma viene chiuso
    exit
  fi

  LECTOR=$(chooseLector) # Selezione lettore
  if [[ -z $LECTOR ]]; then # Se l'utente ha premuto "ANNULLA", il programma viene chiuso
    exit
  fi

  NO_SPACE_LECTOR=${LECTOR//" "/_} # Sostituisco gli spazi con degli underscore
  WORKING_PATH="/home/$USER/DSInstaller/Drivers/$NO_SPACE_LECTOR" # Percorso directory dei drivers
  mkdir -p $WORKING_PATH # Creo la directory in cui scaricare i drivers
  if [[ $? -ne 0 ]] # Mi assicuro che durante la creazione non siano incorsi errori
  then
    dirError # Nel caso si siano verificati degli errori, stampo un messaggio ed esco con segnale 1
  fi
  FILE_DOWNLOAD="$WORKING_PATH/${NO_SPACE_LECTOR}.zip" # Variabile che contiene il percorso del file da salvare ($WORKING_PATH) e il suo nome (l'opzione scelta cui sono stati rimossi spazi e cui è stata aggiunta l'estensione.zip)

# Sulla base di quanto scelto dall'utente, la variabile $URL assumerà un valore appropriato, ossia l'URL del file da scaricare

########## ArubaKey #####################
  if [[ $NO_SPACE_LECTOR = "ArubaKey" ]] # Scelta di ArubaKey
    then
      URL=""
#########################################

########## miniLector POCKET ############
elif [[ $NO_SPACE_LECTOR = "miniLector_POCKET" ]] # Scelta di miniLector POCKET
  then
    URL=""
#########################################

########## miniLector EVO ############
elif [[ $NO_SPACE_LECTOR = "miniLector_EVO" ]] # Scelta di miniLector EVO
  then
    URL=""
######################################

########## miniLector S EVO ############
elif [[ $NO_SPACE_LECTOR = "miniLector_S_EVO" ]] # Scelta di miniLector S EVO
  then
    # https://resources.bit4id.com/files/drivers/linux/dr_minilector_it_linux.zip
    URL="https://resources.bit4id.com/files/drivers/linux/dr_minilector_it_linux.zip"
#######################################

########## miniLector Piano ################
elif [[ $NO_SPACE_LECTOR = "miniLector_Piano" ]] # Scelta di miniLector Piano
  then
    URL=""
############################################

########## miniLector Spaceship ############
elif [[ $NO_SPACE_LECTOR = "miniLector_Spaceship" ]] # Scelta di miniLector Spaceship
  then
    URL=""
############################################
fi
###################### Download dei driver #######################
  zenity --info --title="DSInstaller" --text="Inizierà ora il download dei driver per  <b>$LECTOR</b>. La finestra si chiuderà temporaneamente. <b>NON CHIUDERE IL TERMINALE</b>" --width="400" --height="200"
  wget $URL -O $FILE_DOWNLOAD
  if [[ $? -ne 0 ]] # Se il comando fallisce (restituzione di un segnale diverso da zero)
    then
      downloadError # Visualizza un errore ed esci con segnale 1
  fi
  zenity --info --title="DSInstaller" --text="Il download è terminato. Premere OK per procedere con l'installazione" --width="400" --height="200"
  unzip $FILE_DOWNLOAD -d $WORKING_PATH # Scompattamento dell'archivio scaricato
  
##################################################################
fi

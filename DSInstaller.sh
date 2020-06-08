#! /bin/bash

################## COSE DA FARE (02/03/2020) ##################
# * Snellimento generale
# * Ottimizzare le funzioni (scriverle con meno righe, rendere tutto più leggibile)
# * Progettare nei dettagli l'algoritmo
# * Aggiungere barra progressiva nel download (PROBLEMATICO)
# * Migliorare controllo errori
# * Modularizzare maggiormente il codice
###############################################################

###################### Librerie ################
source ./lib/functions.sh
################################################


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
  WP_LECTOR="/home/$USER/DSInstaller/Lettore/$NO_SPACE_LECTOR" # Percorso directory dei drivers
  mkdir -p $WP_LECTOR # Creo la directory in cui scaricare i drivers
  if [[ $? -ne 0 ]] # Mi assicuro che durante la creazione non siano incorsi errori
  then
    dirError # Nel caso si siano verificati degli errori, stampo un messaggio ed esco con segnale 1
  fi
  FILE_DOWNLOAD="$WP_LECTOR/${NO_SPACE_LECTOR}.zip" # Variabile che contiene il percorso del file da salvare ($WP_LECTOR) e il suo nome (l'opzione scelta cui sono stati rimossi spazi e cui è stata aggiunta l'estensione.zip)

# Sulla base di quanto scelto dall'utente, la variabile $URL_LECTOR assumerà un valore appropriato, ossia l'URL_LECTOR del file da scaricare

########## miniLector POCKET ############
if [[ $LECTOR = "miniLector POCKET" ]] # Scelta di miniLector POCKET
  then
    URL_LECTOR="http://resources.bit4id.com/files/drivers/linux/dr_minilector_it_linux.zip"
#########################################

########## miniLector EVO ############
elif [[ $LECTOR = "miniLector EVO" ]] # Scelta di miniLector EVO
  then
    URL_LECTOR="http://resources.bit4id.com/files/drivers/linux/dr_minilector_evo_it_linux.zip"
######################################

########## miniLector S EVO ############
elif [[ $LECTOR = "miniLector S EVO" ]] # Scelta di miniLector S EVO
  then
    # https://resources.bit4id.com/files/drivers/linux/dr_minilector_it_linux.zip
    URL_LECTOR="https://resources.bit4id.com/files/drivers/linux/dr_minilector_it_linux.zip"
#######################################

########## miniLector Piano ################
elif [[ $LECTOR = "miniLector Piano" ]] # Scelta di miniLector Piano
  then
    URL_LECTOR="http://resources.bit4id.com/files/drivers/linux/dr_minilector_evo_it_linux.zip"
############################################

########## miniLector Spaceship ############
elif [[ $LECTOR = "miniLector Spaceship" ]] # Scelta di miniLector Spaceship
  then
    URL_LECTOR="http://resources.bit4id.com/files/drivers/linux/dr_minilector_spaceship_it_linux.zip"
############################################
fi

###################### Download dei driver del lettore #######################
  zenity --info --title="DSInstaller" --text="Inizierà ora il download dei driver per  <b>$LECTOR</b>. La finestra si chiuderà temporaneamente. <b>NON CHIUDERE IL TERMINALE</b>" --width="400" --height="200"
  wget $URL_LECTOR -O $FILE_DOWNLOAD
  if [[ $? -ne 0 ]] # Se il comando fallisce (restituzione di un segnale diverso da zero)
    then
      downloadError # Visualizza un errore ed esci con segnale 1
  fi
  zenity --info --title="DSInstaller" --text="Il download è terminato. Premere OK per procedere con l'installazione" --width="400" --height="200"
  unzip $FILE_DOWNLOAD -d $WP_LECTOR # Scompattamento dell'archivio scaricato

  #################### INSTALLAZIONE #####################
  if [[ $OS = "Debian, Ubuntu, Linux Mint" ]]; then
    cd $WP_LECTOR # Entrata nella directory di lavoro
    sudo apt install -y ./2008_10_09_libminilector38u-bit4id.deb # La password deve essere inserita nel terminale. AL MOMENTO QUESTO FUNZIONA SOLO PER IL minilector S EVO
  elif [[ $OS =  "Fedora, Red Hat, CentOS" ]]; then
    echo $PASSWORD | sudo -S "rpm -i *.rpm" # Da rivedere
  fi
  ########################################################

##################################################################

zenity  --title="DSInstaller" --info --text="È necessario adesso installare i driver per la SIM / SMART card presente all'interno del lettore. Per sapere quale scegliere, visita la <a href=\"www.google.it\">pagina di aiuto</a>" --width="400" --height="200" # Messaggio di avviso e link per info su scelta smartcard

CARD=$(chooseCard) # Variabile contenente il tipo di card
WP_CARD="$HOME/DSInstaller/Cards/$CARD" # Directory di lavoro per l'installazione dei driver della card
mkdir -p $WP_CARD # Creazione della directory di lavoro

if [[ $? -ne 0 ]] # Mi assicuro che durante la creazione non siano incorsi errori
then
  dirError # Se si sono verificati degli errori, stampo un messaggio ed esco con segnale 1
fi

if [[ $CARD -eq "Incard" || $CARD -eq "Oberthur" ]]; then
    URL_CARD="https://ca.arubapec.it/downloads/MU_LINUX.zip"
elif [[ $CARD -eq "Athena" ]]; then
    URL_CARD="https://ca.arubapec.it/downloads/IDP6.33.02_LINUX.zip"
fi

##################### Download dei driver della card #################
  FILE_DOWNLOAD="$WP_CARD/$CARD.zip"
  wget $URL_CARD -O $FILE_DOWNLOAD
  if [[ $? -ne 0 ]] # Se il comando fallisce (restituzione di un segnale diverso da zero)
    then
      downloadError # Visualizza un errore ed esci con segnale 1
  fi
  unzip $FILE_DOWNLOAD -d $WP_CARD
  if [[ $CARD -eq "Incard" || $CARD -eq "Oberthur" ]]; then
    cd $WP_CARD/linux64
    sudo cp * /usr/lib/
    sudo ldconfig
  elif [[ $CARD -eq "Athena" ]]; then
    echo "Non implementato"
  fi
######################################################################
  zenity  --title="DSInstaller" --info --text="L'installazione è stata completata, si consiglia di riavviare il PC prima di proseguire" --width="400" --height="200" # Messaggio di avviso per il completamento dell'installazione
fi

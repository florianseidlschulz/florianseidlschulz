#!/bin/bash

# In der Softwareentwicklung in der Luftfahrt gibt es eine Baseline.
# Eine Baseline ist eine eingefrorene Linie über mehrere
#Entwicklungsbaustellen (z.Bsp. Hardware, Dokumentation und Software) aehnlich einem globalen Tag.
# Für diesen Stand kann eine Überprüfung durchgegeben werden und diese
#Überprüfung gilt dann nur für diesen Stand.
# Für uns nützlich kann diese Methode sein, um einen funktionierenden
#Stand besser zu kommunizieren
# Diese Script geht recursive über alle Verzeichnisse unter dem
#Ausführungsverzeichniss und pushed den aktuellen Stand
# in einen Branch called EnwicklerShort_Baseline. Nach einem
#abgeschlossenen Arbeitsag (z.Bsp. beim PC-Shutdown) teilt es Fortschritte so
# mit allen andren Teammitgliedern.

SOURCE=$PWD
DEV_NAME = "Florian Seidl-Schulz"
BRANCH_NAME="FSS_BaseLine"
DEV_TAG="Dev_BaseLine"

gitCommitAndTagBaseline() {
    cd "$1"
    git checkout -b "$BRANCH_NAME"
    git add .
    git commit -m "Automatic Base Line Commit for $DEV_NAME"
    CURRENT_DATE=`date`
    git tag -d "$DEV_TAG$CURRENT_DATE$CURRENT_DATE"
    git tag "$DEV_TAG$CURRENT_DATE"
    git push
    git checkout master
}

traverse() {
    for file in $(ls "$1")
    do
        #current=${1}{$file}
        if [[ ! -d ${1}/${file} ]]; then
            echo " ${1}/${file} is a file"
        else
            if [ -d "${1}/${file}/.git" ]; then
                echo "commiting to baseline for ${1}/${file}"
                gitCommitAndTagBaseline "${1}/${file}"
            else
                traverse "${1}/${file}"
            fi
        fi
    done
}

echo "Establishing baseline in folder: $SOURCE"
traverse $SOURCE
# Selectanfrage für den 6. Projectathon der MII: MIRACUM
Datum: 30.11.21

Autorin: [Nandhini.Santhanam@medma.uni-heidelberg.de](mailto:nandhini.santhanam@medma.uni-heidelberg.de).

Dieses Project führt die Select-Anfrage für das MIRACUM  Projekt im Rahmen des 6. Projectathons aus. Hier ist eine zentrale Analyse vorgesehen. Dafür erzeugt dieses Skript zwei Tabellen mit den für die Analyse benötigten Inhalten. Diese Tabellen sollen zentral zusammengeführt und an die datenauswertendende Stelle übergeben werden.

Das Readme beschreibt zunächst die technischen Details der Verwendung. Darunter sind die verwendeten CodeSysteme/Ressourcen/Profile und der konzeptionelle Ablauf der Abfrage beschrieben.

## Verwendung
Es gibt zwei Möglichkeiten diese R-Skripte auszuführen: Direkt in R oder in einem Docker Container. Beide werden im folgenden beschrieben.

### Ausführung in R
#### Vor der ersten Nutzung
1. Um die Selectanfrage durchzuführen, muss der Inhalt des Git-Repository auf einen Rechner (PC, Server) gezogen werden, von dem aus der REST-Endpunkt des gewünschten FHIR-Servers (z.B. FHIR-Server der Clinical Domain im DIZ) erreichbar ist. 

2. Auf diesem Rechner muss R (aber nicht notwendigerweise RStudio) als genutzte Laufzeitumgebung installiert sein.

3. Die mitgelieferte Datei `./config_default.yml` muss nach `./config.yml` kopiert werden und lokal angepasst werden (serverbase, ggf. Authentifizierung - Username and password); Erklärungen dazu finden sich direkt in dieser Datei. Eine Authentifizierung mit Basic Authentication. Dafür müssen in `config.yml` die Variable `authentication` und die zugehörigen Zugangsdaten (`password`/`username`) angepasst werden.
  

4. Wenn die App über `runSmith_select.bat` (unter Windows) gestartet soll, muss in dieser der Pfad zur Datei `Rscript.exe` geprüft und ggf. angepasst werden (z.B. `C:\Program Files\R\R-4.0.4\bin\Rscript.exe`).


#### Start des Skripts
Beim ersten Start des Skripts wird überprüft, ob die zur Ausführung notwendigen R-Pakete ("rprojroot","fhircrackr","config","dplyr","zoo","stringr","tidyr") vorhanden sind. Ist dies nicht der Fall, werden diese Pakete nachinstalliert – dieser Prozess kann einige Zeit in Anspruch nehmen.

##### Batch-Datei/Shell-Skript
**Unter Windows**: Mit der Batch-Datei `runMIRACUM_select.bat`.
Beim ersten Ausführen sollte diese ggf. als Administrator gestartet werden (über Eingabeaufforderung oder Rechtsklick), wenn die ggf. notwendigen Berechtigungen zum Nachinstallieren der R-Pakete sonst nicht vorhanden sind. Nach der ersten Installation reicht dann ein Doppelklick zum Starten.

**Unter Linux**: Mit dem Shell-Skript `runMIRACUM_select.sh`. Das Shell-Skript muss ausführbar sein und ggf. beim ersten Ausführen mittels `sudo` gestartet werden, wenn ein Nachinstallieren der R-Pakete außerhalb des User-Kontexts erforderlich ist.

#### R/RStudio
Durch Öffnen des R-Projektes (`Projectathon6-miracum1.Rproj`) mit anschließendem Ausführen der Datei `miracum_select.R` innerhalb von R/RStudio. Auch hier werden beim ersten Ausführen ggf. notwendige R-Pakete nachinstalliert.


## Ausführung im Docker Container
Um die Abfrage in einem Docker Container laufen zu lassen gibt es drei Möglichkeiten:

**A) Image von DockerHub ziehen:**
1. Git-Respository klonen: `git clone https://github.com/NandhiniS08/Projectathon6-miracum1.git`
2. Verzeichniswechsel in das lokale Repository: `cd Projectathon6-miracum1`
3. Konfiguration lokal anpassen: `./config_default.yml` nach `./config.yml` kopieren und anpassen 
4. Image downloaden und Container starten: `docker run --name projectathon6-miracum1 -v "$(pwd)/errors:/errors" -v "$(pwd)/Bundles:/Bundles" -v "$(pwd)/Ergebnisse:/Ergebnisse" -v "$(pwd)/config.yml:/config.yml" NandhiniS08/projectathon6-miracum1`


**B) Image bauen mit Docker Compose:**

1. Git-Respository klonen: `git clone https://github.com/NandhiniS08/Projectathon6-miracum1.git`
2. Verzeichniswechsel in das lokale Repository: `cd Projectathon6-miracum1`
3. Konfiguration lokal anpassen: `./config_default.yml` nach `./config.yml` kopieren und anpassen
4. Image bauen und Container starten: `docker compose up -d`

Zum Stoppen des Containers `docker compose stop`. Um ihn erneut zu starten, `docker compose start`.

**C) Image bauen ohne Docker Compose**

1. Git-Respository klonen: `git clone https://github.com/NandhiniS08/Projectathon6-miracum1.git`
2. Verzeichniswechsel in das lokale Repository: `cd Projectathon6-miracum1`
3. Image bauen: `docker build -t projectathon6-miracum1 .` 
4. Konfiguration lokal anpassen:  `./config_default.yml` nach `./config.yml` kopieren und anpassen
5. Container starten: `docker run --name projectathon6-miracum1 -v "$(pwd)/errors:/errors" -v "$(pwd)/Bundles:/Bundles" -v "$(pwd)/Ergebnisse:/Ergebnisse" -v "$(pwd)/config.yml:/config.yml" projectathon6-miracum1`

Erklärung:

-  `-v "$(pwd)/config.yml:/config.yml""` bindet die lokal veränderte Variante des config-Files ein. Wenn dieses geändert wird, reicht es, den Container neu zu starten (`docker stop Projectathon6-miracum1`, config.yml ändern, dann `docker start Projectathon6-miracum1`), ein erneutes `docker build` ist nicht nötig.


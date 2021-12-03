# Selectanfrage für den 6. Projectathon der MII: MIRACUM "WE-STORM"
Datum: 01.12.21

Autoren: [Nandhini.Santhanam@medma.uni-heidelberg.de](mailto:nandhini.santhanam@medma.uni-heidelberg.de) & [Maros@uni-heidelberg.de](mailto:Maros@uni-heidelberg.de)

Dieses Project führt die Select-Anfrage für das MIRACUM ("WE-STORM") Projekt im Rahmen des 6. Projectathons aus. Hier ist eine dezentrale Analyse (distributed On-Site and Federated Learning)vorgesehen. Dieses Skript (Step 1) erzeugt mehreren Tabellen mit aggregierten Daten, die für die Planung der statistischen Analysen (Step 2) benötigt werden. Diese Tabellen sollen zuerst zentral evaluiert werden und somit an die datenauswertendende Stelle (MIRACUM, Mannheim) übergeben werden.

Das Readme beschreibt zunächst die technischen Details der Verwendung. Darunter sind die verwendeten CodeSysteme/Ressourcen/Profile und der konzeptionelle Ablauf der Abfrage beschrieben.

## Verwendung
Es gibt zwei Möglichkeiten diese R-Skripte auszuführen: Direkt in R oder in einem Docker Container. Beide werden im folgenden beschrieben.

### Ausführung in R
#### Vor der ersten Nutzung
1. Um die Selectanfrage durchzuführen, muss der Inhalt des Git-Repository auf einen Rechner (PC, Server) gezogen werden, von dem aus der REST-Endpunkt des gewünschten FHIR-Servers (z.B. FHIR-Server der Clinical Domain im DIZ) erreichbar ist. 

2. Auf diesem Rechner muss R (aber nicht notwendigerweise RStudio) als genutzte Laufzeitumgebung installiert sein.

3. Die mitgelieferte Datei `./config_default.yml` muss nach `./config.yml` kopiert werden und lokal angepasst werden (serverbase, ggf. Authentifizierung - Username and password); Erklärungen dazu finden sich direkt in dieser Datei. Eine Authentifizierung mit Basic Authentication. Dafür müssen in `config.yml` die Variable `authentication` und die zugehörigen Zugangsdaten (`password`/`username`) angepasst werden.
  

4. Wenn die App über `runMiracum_select.bat` (unter Windows) gestartet soll, muss in dieser der Pfad zur Datei `Rscript.exe` geprüft und ggf. angepasst werden (z.B. `C:\Program Files\R\R-4.0.4\bin\Rscript.exe`).


#### Start des Skripts
Beim ersten Start des Skripts wird überprüft, ob die zur Ausführung notwendigen R-Pakete ("rprojroot","fhircrackr","config","dplyr","zoo","stringr","tidyr") vorhanden sind. Ist dies nicht der Fall, werden diese Pakete nachinstalliert – dieser Prozess kann einige Zeit in Anspruch nehmen.

##### Batch-Datei/Shell-Skript
**Unter Windows**: Mit der Batch-Datei `runMIRACUM_select.bat`.
Beim ersten Ausführen sollte diese ggf. als Administrator gestartet werden (über Eingabeaufforderung oder Rechtsklick), wenn die ggf. notwendigen Berechtigungen zum Nachinstallieren der R-Pakete sonst nicht vorhanden sind. Nach der ersten Installation reicht dann ein Doppelklick zum Starten.

**Unter Linux**: Mit dem Shell-Skript `runMIRACUM_select.sh`. Das Shell-Skript muss ausführbar sein und ggf. beim ersten Ausführen mittels `sudo` gestartet werden, wenn ein Nachinstallieren der R-Pakete außerhalb des User-Kontexts erforderlich ist.

_Debugging/Error:_ Im Falle eines Berechtigungsfehlers soll der folgende Befehl vor dem ausführen des o.b. Shell-Skripts noch zusätzlich ausgeführt werden: `chmod -R 777 ./` 

#### R/RStudio
Durch Öffnen des R-Projektes (`Projectathon6-miracum1.Rproj`) mit anschließendem Ausführen der Datei `miracum_select.R` innerhalb von R/RStudio. Auch hier werden beim ersten Ausführen ggf. notwendige R-Pakete nachinstalliert.

## Ausführung im Docker Container
Um die Abfrage in einem Docker Container laufen zu lassen gibt es zwei Möglichkeiten:

<!--- 
DockerHub option will be updated
**A) Image von DockerHub ziehen:**
1. Git-Respository klonen: `git clone https://github.com/NandhiniS08/Projectathon6-miracum1.git`
2. Verzeichniswechsel in das lokale Repository: `cd Projectathon6-miracum1`
3. Konfiguration lokal anpassen: `./config_default.yml` nach `./config.yml` kopieren und anpassen 
4. Image downloaden und Container starten: `docker run --name projectathon6-miracum1 -v "$(pwd)/errors:/errors" -v "$(pwd)/Bundles:/Bundles" -v "$(pwd)/Summary:/Summary" -v "$(pwd)/Ergebnisse:/Ergebnisse" -v "$(pwd)/config.yml:/config.yml" NandhiniS08/projectathon6-miracum1`
--->

**A) Image bauen mit Docker Compose:**
1. Git-Respository klonen: `git clone https://github.com/NandhiniS08/Projectathon6-miracum1.git`
2. Verzeichniswechsel in das lokale Repository: `cd Projectathon6-miracum1`
3. Konfiguration lokal anpassen: `./config_default.yml` nach `./config.yml` kopieren und anpassen
4. Image bauen und Container starten: `docker compose up -d`

Zum Stoppen des Containers `docker compose stop`. Um ihn erneut zu starten, `docker compose start`.

**B) Image bauen ohne Docker Compose**
1. Git-Respository klonen: `git clone https://github.com/NandhiniS08/Projectathon6-miracum1.git`
2. Verzeichniswechsel in das lokale Repository: `cd Projectathon6-miracum1`
3. Image bauen: `docker build -t projectathon6-miracum1 .` 
4. Konfiguration lokal anpassen:  `./config_default.yml` nach `./config.yml` kopieren und anpassen
5. Container starten: `docker run --name projectathon6-miracum1 -v "$(pwd)/errors:/errors" -v "$(pwd)/Bundles:/Bundles" -v "$(pwd)/Ergebnisse:/Ergebnisse" -v "$(pwd)/config.yml:/config.yml" projectathon6-miracum1`

Erklärung:

-  `-v "$(pwd)/config.yml:/config.yml""` bindet die lokal veränderte Variante des config-Files ein. Wenn dieses geändert wird, reicht es, den Container neu zu stoppen und starten (`docker stop Projectathon6-miracum1`, `config.yml` ändern, dann `docker start Projectathon6-miracum1`), ein erneutes `docker build` ist nicht nötig.


## Output 
Das Skript erzeugt mehrere Ordner im Projekt-Directory. Um für den Projectathon eine möglichst einfache übersichtliche Lösung zu bekommen, werden alle files, die darin erzeugt werden bei mehrmaligem Ausführen ggf. einfach überschrieben.

### Ergebnisse
Wenn die Abfrage erfolgreich durchgeführt wurde, sind hier zwei Gruppen von csv-Dateien zu finden.
In der ersten Gruppe befinden sich 3 `.csv` Dateien mit den orignalen Quelldaten:
- `Kohorte.csv` inkl. alle Patienten mit den Pflichtdatenfelder(patient_id, birth_date, gender, patient_zip) Und Informationen über den Besuch des Patienten im Krankenhaus - Aufnahmedatum, ICD, Rang (Haupt-/Nebendiagnose) und verschiedene damit zusammenhängende Merkmale (intravenous lyse therapy (IVT) , Admission to the ICU, Admission to the stroke unit, Neurosurgery, Thrombectomy, Intrakraniell Stent)  und Kardiovaskuläre Risikofaktoren und metabolische Komorbiditäten
- `Medication.csv` inkl. alle Resourcen bzgl. Patientenaufnahmen (encouter_id) und die erhaltene Medikation (code)
- `Observations.csv` inkl. patient_id und encounter_id sowie LOINC-Codes (value & unit)
### Summary
Analog dazu befinden sich in der zweiten Gruppe die zusammengefasste/aggregierte Count-Daten der obigen Tabellen: 
- `Cohort_Summary.csv` gruppiert für die Quartale (z.B. 2020/Q1, ...)
- `Medication_Summary.csv` Anzahl der Fälle gruppierte nach Medikationstyp  
- `Observation_Summary.csv` Anzahl der Fälle gruppierte entsprechend der verfügbaren Laborwerte
- `Procedure_Summary.csv` Anzahl der Fälle gruppierte entsprechend der verfügbaren Procedures
- `StrokeDiagnosis_Summary.csv` Anzahl der Fälle gruppierte entsprechend der verfügbaren Stroke diagnosen ICD

Diese sind benötigt um die möglichste größte und feature-reicshte homogene Kohrote über alle Standorten hinweg für die statistische Auswertung selektieren zu können. 

## Verwendete Codesysteme
  Dieses System wird für den Download per FHIR Search verwendet
- http://fhir.de/CodeSystem/dimdi/icd-10-gm für Condition.code.coding.system
- http://fhir.de/CodeSystem/dimdi/ops für Procedure.code.coding.system
- http://loinc.org für Observation.code.coding.system
- http://fhir.de/CodeSystem/dimdi/atc für Medication.code.coding.system


## Verwendete Profile/Datenelemente
The queries are written based on the MII profiles for the corresponding resources. The scripts are compatible with the latest release of the available major versions. The following describes, for each resource type used, which elements are used for the FHIR search query to the server (these elements must be present to avoid throwing an error) and which elements are extracted in the script and written to the results tables.

### Modul Person: Patient
Profil: https://www.medizininformatik-initiative.de/fhir/core/modul-person/StructureDefinition/Patient

Version: 2.0.0-alpha3 bzw. 1.0.14

Für Servabfrage verwendete Elemente:

keine
Extrahierte Elemente:

* Patient.id
* Patient.gender
* Patient.birthDate
* Patient.address.postalCode

### Modul Fall: Encounter
Profil: https://www.medizininformatik-initiative.de/fhir/core/modul-fall/StructureDefinition/KontaktGesundheitseinrichtung

Version: 1.0.1

Extrahierte Elemente:

* Encounter.id
* Encounter.subject.reference
* Encounter.period.start
* Encounter.diagnosis.condition.reference
* Encounter.diagnosis.rank
* Encounter.hospitalization.dischargeDisposition.coding.code
### Modul Diagnose: Condition
Profil: https://www.medizininformatik-initiative.de/fhir/core/modul-diagnose/StructureDefinition/Diagnose

Version: 2.0.0-alpha3 bzw. 1.0.4

Für Servabfrage verwendete Elemente:

* Condition.subject.reference

Extrahierte Elemente:

* Condition.id
* Condition.recordedDate
* Condition.code.coding.code
* Condition.code.coding.system
* Condition.encounter.reference
* Condition.subject.reference

### Modul Prozedur: Procedure
Profil: https://www.medizininformatik-initiative.de/fhir/core/modul-prozedur/StructureDefinition/Procedure

Version: 2.0.0-alpha3 bzw. 1.0.4

Für Servabfrage verwendete Elemente:

* Procedure.subject.reference

Extrahierte Elemente:

* Procedure.id
* Procedure.performedDateTime
* Procedure.code.coding.code
* Procedure.code.coding.system
* Procedure.encounter.reference
* Procedure.subject.reference


### Modul Labor: Observation
Profil: https://www.medizininformatik-initiative.de/fhir/core/modul-labor/StructureDefinition/ObservationLab

Version: 1.0.6

Extrahierte Elemente:

* Observation.id
* Observation.effectiveDateTime
* Observation.code.coding.code
* Observation.code.coding.system
* Observation.subject.reference
* Observation.valueQuantity.value
* Observation.valueQuantity.unit
* Observation.subject.reference
* Observation.encounter.reference


### Modul Medikation and MedicationStatement
Profil: https://www.medizininformatik-initiative.de/fhir/core/modul-medikation/StructureDefinition/MedicationStatement
Version: 1.0.6

Extrahierte Elemente:
* MedicationStatement.medication
* Medication.code.coding.code
* Medication.code.coding.system


## Konzeptioneller Ablauf der Abfrage
In principle, the script proceeds as follows:
1. It connects to the FHIR server to download all encounter resources who has the below mentioned stroke diagnosis from the period of 2016-01-01 to current date.
   ICD10: I60.0,I60.1,I60.2,I60.3,I60.4,I60.5,I60.6,I60.7,I60.8,I60.9,I61.0,I61.1,I61.2,I61.3,I61.4,I61.5,I61.6,I61.8,I61.9,
          I63.0,I63.1,I63.2,I63.3,I63.4,I63.5,I63.6,I63.8,I63.9,I67.80!
2. It also downloads all the referenced Patient, condition and procedure resources by the obtained encounter resources. i.e. it downloads all the patient,condition and procedures where the encounters obtained in step is also downloaded.
 Request:   [base]/Encounter?date=ge2015-01-01&_has:Condition:encounter:code=I60.0,I60.1,I60.2,I60.3,I60.4,I60.5,I60.6,I60.7,I60.8,I60.9,I61.0,I61.1,I61.2,I61.3,I61.4,I61.5,I61.6,I61.8,I61.9,I63.0,I63.1,I63.2,I63.3,I63.4,I63.5,I63.6,I63.8,I63.9,I67.80!&_include=Encounter:patient&_revinclude=Condition:encounter&_revinclude=Procedure:encounter&_parameter_count=500
 3. After these resources are downloaded, necessary processing is done using FHIRCrackR package and converted into dataframe with relevant features for the encounters with relevant diagnosis.
 4. The list of encounter and patient ids are extracted from the extracted resources and this is used for downloading further resources such as observation and medication.
 5. The observation resource is downloaded for the list of encounter ids and LOINC code taht are listed below
      777-3,6301-6,3173-2,2160-0,2089-1,2085-9,7799-0,4548-4,2345-7,2093-3,74201-5
      Request: [base]Observation?encounter=xx&code=777-3,6301-6,3173-2,2160-0,2089-1,2085-9,7799-0,4548-4,2345-7,2093-3,74201-5
      xx indicates list of encounter ids
 6. The medicationStatement resources are downloaded for the list of encounters from which the relevant medication id is obtained, which is then used to extract the actual medication resources
       Request: [Base]/Medication?id=xx 
        xx indicates list of medication ids
 8.  Inorder to obtain the past comorbidities related to cardiovasular risk and metabollic risks, condition resource is extracted for the list of patient and relevant features are created based on the ICD10 codes.
    Request: [Base]/Condition?subject=xx  
    xx indicates list of patient ids
 9.  Once all these resources are downloaded, various dataframes are created in R for the whole data and also different summaries that arre saved as csv. The details about the same are mentioned in the output section above 
         






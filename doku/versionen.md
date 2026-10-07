# Versionshinweise

Was sich mit jeder Version geändert hat. Steht unter **Status** ein Hinweis, lesen Sie ihn vor dem Update; wie das Update selbst abläuft, steht unter [Aktualisieren](aktualisieren.html).

## NETbrain 0.4.16

**Stand:** 6. Oktober 2026

**Status:** Keine Eingriffe nötig.

### KI-Zugang prüfen

Scheitert die Prüfung eines KI-Anbieters, nennt NETbrain jetzt die Ursache: keine Antwort
(meist eine Firewall), Name nicht auflösbar, Verbindung abgewiesen, ungültiges Zertifikat
oder abgelehnter API-Schlüssel.

### Installation und Updates

Installer und Update-Prüfung hinterlassen keine leeren Docker-Volumes mehr. Ältere Reste
entfernt `docker volume prune` (löscht nur namenlose Volumes, die kein Container nutzt).

## NETbrain 0.4.15

**Stand:** 6. Oktober 2026

**Status:** Keine Eingriffe nötig.

### Installation

- `install.sh` prüft nach dem Start, ob der Container nach außen kommt. Ist
  `/etc/resolv.conf` leer, obwohl systemd-resolved läuft, verlinkt es die Datei auf
  `stub-resolv.conf` (die alte bleibt als Sicherung liegen) und startet Docker neu. In
  allen anderen Fällen erscheint eine Warnung mit den Punkten, die zu prüfen sind.
- `install.sh token` meldet nach abgeschlossener Einrichtung „bereits eingerichtet" statt
  eines alten Tokens.

### Einrichtungsassistent

- Scheitert die Prüfung des KI-Zugangs, erscheint wieder das Formular mit der Fehlermeldung.
- Nach dem Probelauf der Sicherung führt „Weiter" zum nächsten Schritt.
- Der Hinweis zur Alpha-Version zeigt keinen hellen Rahmen mehr.

## NETbrain 0.4.14

**Stand:** 1. Oktober 2026

**Status:** Keine Eingriffe nötig.

### Betriebszustand in der Administration

Unter **Verwaltung → Übersicht** stehen jetzt Speicherplatz, Sicherung, Lizenz und
Kundenportal mit Ampel und Klartext — dieselben Prüfungen wie unter `/api/monitor/`.
Den Token für die Überwachung von außen erzeugt NETbrain dort per Knopf; die Compose-Datei
muss dafür niemand mehr anfassen. Fehlt das Sicherungsverzeichnis noch, misst die
Speicherprüfung den Datenträger, auf dem es entsteht.

## NETbrain 0.4.13

**Stand:** 1. Oktober 2026

**Status:** Keine Eingriffe nötig. Für die neue Überwachung `NETBRAIN_MONITOR_TOKEN` setzen.

### Überwachung für Uptime Kuma und Co.

Vier neue Endpunkte, je 200 oder 503, nur mit Token (`NETBRAIN_MONITOR_TOKEN`, als
`Authorization: Bearer …`):

- `/api/monitor/speicher` — Belegung von Daten- und Sicherungsablage in Prozent; 503 über 90 %
  (`NETBRAIN_MONITOR_SPEICHER_PROZENT`).
- `/api/monitor/sicherung` — letzter Lauf gescheitert oder älter als 26 Stunden.
- `/api/monitor/lizenz` — weniger als 14 Tage Restlaufzeit, gesperrt oder seit 48 Stunden
  nicht vom Lizenzdienst bestätigt.
- `/api/monitor/portal` — Abgleich mit dem Kundenportal gescheitert oder älter als 30 Minuten.

Ohne Token gibt es die Endpunkte nicht. Anleitung:
https://getnetbrain.netfactory.de/doku/ueberwachung.html

## NETbrain 0.4.12

**Stand:** 1. Oktober 2026

**Status:** Für Kubernetes und App-Plattformen wichtig: Probes auf `/api/live` und `/api/ready` umstellen. Docker-Installationen: keine Eingriffe nötig.

### Eigene Endpunkte für Container-Probes

- **`/api/live`** (Liveness) antwortet, solange der Prozess lebt.
- **`/api/ready`** (Readiness) prüft Ablage und Migration.

Beide antworten unabhängig vom Host-Header, von Einrichtung und Lizenz. Bisher diente
`/api/health` als Probe; es meldet 503, solange die Lizenz fehlt. Auf Kubernetes führte das
zu einer Neustart-Schleife, und eine Installation ohne Lizenz erreichte ihre eigene
Lizenzseite nicht. `/api/health` bleibt unverändert und dient der Überwachung. Auch die
Healthprobe eines Reverse-Proxys gehört auf `/api/ready`.

## NETbrain 0.4.11

**Stand:** 1. Oktober 2026

**Status:** Keine Eingriffe nötig. Für das neue Erscheinungsbild auch den Portal-Container auf 0.4.11 bringen.

### Kundenportal im eigenen Erscheinungsbild

Unter **Verwaltung → Kundenportal → Erscheinungsbild**: Name in der Kopfzeile, Einleitung,
eigenes Logo (PNG, JPEG, WebP bis 512 KB), Akzentfarbe, helles oder dunkles Design sowie
Verweise auf Impressum, Datenschutzerklärung und eine Kontaktadresse in der Fußzeile. Zu
schwach kontrastierende Akzentfarben gleicht das Portal für Links lesbar ab. Logo und
Einstellungen gehen mit in die Sicherung.

## NETbrain 0.4.10

**Stand:** 1. Oktober 2026

**Status:** Keine Eingriffe nötig; Daten und Lizenzen bleiben unverändert.

### Kundenportal: Schlüssel eintragen

Der Kopplungsschlüssel lässt sich jetzt auch eintragen statt erzeugen — unter
**Verwaltung → Kundenportal → Schlüssel eintragen** und im Einrichtungsassistenten. So kann
eine App-Plattform den Schlüssel vorgeben (`PORTAL_SYNC_KEY`) und mit der Portal-Adresse
anzeigen; am Portal selbst ist nichts einzurichten. NETbrain gleicht nach dem Eintragen sofort ab.

### Weitere Änderungen

- Nach dem Aktivieren einer Lizenz bestätigt die Lizenzseite und leitet zur Anwendung weiter.
- Wissensseiten: Aktionen stehen neben dem Titel, der Portal-Status als Zeile darunter.
- Kundenportal: Das Logo erscheint im richtigen Seitenverhältnis.

## NETbrain 0.4.9

**Stand:** 1. Oktober 2026

**Status:** Keine Eingriffe nötig; Daten und Lizenzen bleiben unverändert.

### Kundenportal im Backup

Die Sicherung enthält jetzt auch die Freigaben für das Kundenportal (`/data/portal.json`).
Beim Wiederherstellen kommt dafür `--portal <Zielpfad>` hinzu; ältere Sicherungen bleiben
lesbar.

## NETbrain 0.4.8

**Stand:** 30. September 2026

**Status:** Korrekturfassung zu 0.4.7. Keine Eingriffe nötig; Daten und Lizenzen bleiben unverändert.

### Anmeldung nach der Einrichtung repariert

Mit 0.4.7 konnte sich der erste Administrator nach der Einrichtung nicht anmelden: Die
Pflicht zur Zwei-Faktor-Anmeldung und die Lizenzprüfung leiteten sich gegenseitig weiter, der
Browser zeigte eine leere Seite. Behoben:

- Die Einrichtung richtet die Zwei-Faktor-Anmeldung des ersten Administrators gleich mit ein
  (QR-Code scannen, Code eingeben). Die Wiederherstellungscodes zeigt die Anmeldeseite danach
  einmal an — bitte notieren.
- Die Einrichtung der Zwei-Faktor-Anmeldung ist immer erreichbar, auch ohne gültige Lizenz.

Eine bereits eingerichtete 0.4.7-Installation muss nicht neu aufgesetzt werden: Nach dem
Update öffnet die Anmeldung die Einrichtung der Zwei-Faktor-Anmeldung.

### Gestaltete Fehlerseiten

Fehler (etwa „Seite nicht gefunden") erscheinen im NETbrain-Design statt als leere Textseite.

### Neu: Kundenportal (eigene Lizenz)

Kuratoren können einzelne Wissensseiten für ein öffentliches Kundenportal freigeben — mit
Bestätigung, jederzeit widerrufbar. Das Portal läuft als eigener Container
(`ghcr.io/netfactory-gmbh/netbrain-portal`) unter eigener Adresse und zeigt die Seiten ohne
Anmeldung, mit Suche. Einrichtung im Assistenten (überspringbar) oder unter
**Verwaltung → Kundenportal**. Das Portal ist nur mit einer Lizenz verfügbar, die es enthält;
die Testlizenz enthält es. Fragen zur Lizenz: info@netfactory.de

## NETbrain 0.4.7

**Stand:** 30. September 2026

**Status:** Bitte vorab ankündigen: Jedes Konto richtet beim nächsten Anmelden die
Zwei-Faktor-Anmeldung ein. Daten und Lizenzen bleiben unverändert.

### Zwei-Faktor-Anmeldung ist Pflicht

Nach dem Passwort fragt NETbrain einen sechsstelligen Code aus einer Authenticator-App ab
(z. B. Microsoft Authenticator, Google Authenticator, 1Password). Beim ersten Anmelden nach dem
Update richtet jedes Konto sie ein: QR-Code scannen, Code eingeben, zehn
Wiederherstellungscodes notieren. Bis dahin sind die übrigen Seiten gesperrt.

- Unter **Mein Konto → Zwei-Faktor-Anmeldung**: neues Gerät einrichten, neue
  Wiederherstellungscodes erzeugen.
- Administratoren setzen die Zwei-Faktor-Anmeldung eines Kontos in der Benutzerverwaltung
  zurück, etwa bei verlorenem Handy.
- Hat sich der letzte Administrator ausgesperrt, hilft auf dem Server:
  `docker compose exec netbrain node scripts/user.mjs --2fa-reset <benutzername>`
- Wer sie freiwillig machen will: `NETBRAIN_2FA_OPTIONAL: "true"` in der Compose-Datei.

### NETbrain als App

NETbrain lässt sich im Browser als App installieren (Chrome, Edge, Android, iOS über „Zum
Home-Bildschirm"). Gespeichert werden dabei nur Programmdateien, kein Wissen und keine Inhalte.

## NETbrain 0.4.6

**Stand:** 30. September 2026

**Status:** Keine Eingriffe nötig; bestehende Installationen und Lizenzen laufen unverändert weiter.

### Einrichtung hinter einem HTTPS-Proxy

Hinter einem Reverse-Proxy oder Ingress, der TLS beendet, brach jedes Formular — zuerst die
Eingabe des Einrichtungs-Tokens — mit „Cross-site POST form submissions are forbidden" ab.
Behoben: NETbrain erkennt die HTTPS-Adresse des eigenen Hostnamens jetzt auch dann als eigene
Herkunft, wenn der Proxy per HTTP weiterreicht. Voraussetzung: Der Proxy lässt den
`Host`-Header unverändert. `NETBRAIN_ALLOWED_HOSTS` ist dafür nicht nötig.

### Weitere Änderungen

- Firmenwissen aus dem Gesprächsverlauf geht nur mit Zustimmung an einen Cloud-Anbieter.
- Große Wissensbestände werden langsamer statt unbenutzbar.
- Testlizenz mit dynamischem Ablaufdatum; neue Favicons und Logo.

## NETbrain 0.4.5

**Stand:** 21. September 2026

**Status:** Korrekturfassung zur Testlizenz. Bestehende Installationen und Lizenzen laufen
unverändert weiter; eine bereits eingespielte Testlizenz bleibt gültig.

### Die Testlizenz kommt jetzt wirklich an

In 0.4.4 trug die Mail mit der Testlizenz zwar die richtige Empfängeradresse im Kopf,
zugestellt wurde sie aber an das Postfach des Herausgebers. Wer eine Testlizenz angefordert
hat, bekam nichts. Das ist behoben — die Mail geht an die Adresse aus dem Antrag.

Wer in den letzten Tagen vergeblich gewartet hat: Eine zweite Anfrage mit derselben Adresse
wird abgewiesen, weil je Adresse eine Testlizenz vorgesehen ist. Melden Sie sich in dem Fall
bei uns, wir stellen sie von Hand aus.

### Lizenz als Dateianhang

Die Lizenz hängt der Mail jetzt als `license.json` an, statt als Textblock zum Markieren im
Nachrichtentext zu stehen. Damit fällt das Kopieren weg: Datei herunterladen, unter
**Lizenz & Aktivierung** hochladen, fertig. Ein abgeschnittener oder umgebrochener Textblock
kann so nicht mehr passieren.

### Für Administratoren: Einrichtungs-Token vorgeben

Wird NETbrain aus einer Anwendungsplattform heraus gestartet, kann die Plattform das
Einmal-Token für die Ersteinrichtung jetzt selbst setzen, statt es aus dem Containerprotokoll
zu fischen:

    NETBRAIN_SETUP_TOKEN=<mindestens 24 Zeichen>

Damit lässt sich der Einrichtungslink fertig aufgebaut an den Kunden ausgeben. Ohne die
Variable verhält sich NETbrain wie bisher und würfelt das Token beim Start selbst aus. Ein
zu kurzer Wert wird verworfen — mit einem Hinweis im Protokoll — und durch ein gewürfeltes
ersetzt. Einzelheiten stehen in `plattform-bereitstellung.md`.

## NETbrain 0.4.4

**Stand:** 18. September 2026

**Status:** Keine Eingriffe nötig; bestehende Installationen und Lizenzen laufen unverändert weiter.

### Testlizenz direkt aus NETbrain anfordern

Wer noch keine Lizenzdatei hat, fordert sie jetzt in der Anwendung an: unter **Lizenz &
Aktivierung** und im Einrichtungsassistenten steht „Testlizenz anfordern" — Firma, Name,
Mailadresse, fertig. Die Lizenz kommt per Mail und wird wie jede andere eingefügt.

Sie läuft **sieben Tage** und danach ohne Übergangsfrist aus; eine reguläre Lizenz hat die
sieben Tage Nachlauf weiterhin. Je Mailadresse gibt es eine Testlizenz. An Ihrem Bestand
ändert das nichts: Läuft die Testphase ab, bleiben Lizenzseite, Export und der private
Vault erreichbar, und mit der eingespielten Lizenz steht sofort wieder alles offen.

Übertragen werden nur Firma, Name und Mailadresse. Inhalte aus Ihrer Installation gehen
dabei nicht hinaus.

## NETbrain 0.4.3

**Stand:** 18. September 2026

**Status:** Sicherheitsaktualisierung. Keine Eingriffe nötig, keine sichtbaren Änderungen.

Diese Fassung hebt vier Fremdbibliotheken auf ihre fehlerbereinigten Stände. Zwei davon
betreffen die Verarbeitung hochgeladener Dateien und sind der Grund, warum die
Aktualisierung nicht bis zur nächsten Funktionsfassung warten sollte:

- **Bildoptimierung** (`astro`, `sharp`): Präparierte Bilddateien konnten die
  Dekodierbibliothek zum Absturz oder Schlimmerem bringen. NETbrain verarbeitet jedes
  hochgeladene Bild — damit war der Weg über ein angemeldetes Konto offen.
- **Frontmatter** (`js-yaml`): Eine besonders verschachtelte Notiz konnte den Server
  rechnen lassen, bis er nicht mehr antwortete.
- **SVG-Bereinigung** (`svgo`): Die Entfernung ausführbarer Anteile aus SVG-Dateien war
  unvollständig.

Alle vier setzen ein Konto auf Ihrer Installation voraus; von außen war nichts davon
erreichbar. An der Bedienung ändert sich nichts.

## NETbrain 0.4.2

**Stand:** 18. September 2026

**Status:** Keine Eingriffe nötig; bestehende Installationen und Lizenzen laufen unverändert weiter.

An der Anwendung ändert sich in dieser Fassung nichts: Ihr Wissensbestand, die Suche, der
private Vault und der KI-Chat verhalten sich wie bisher. Geändert hat sich, wie eine neue
Installation zu ihrer Lizenz kommt.

### Sieben Tage ohne Lizenz

Eine frisch aufgesetzte Installation ist ab dem ersten Start **sieben Tage vollständig
nutzbar**. Ein Hinweisband am oberen Rand nennt die verbleibende Zeit. Die Lizenzdatei
lässt sich jederzeit unter `/lizenz` nachtragen.

Läuft die Testphase ab, ohne dass eine Lizenz hinterlegt wurde, bleiben die Lizenzseite,
der Export des Firmenwissens und Ihr lokaler privater Vault erreichbar. **Es geht nichts
verloren** — mit der eingespielten Lizenz steht sofort wieder alles offen.

### Für Administratoren

- **Einrichtung:** Schritt 6 des Assistenten lässt sich mit „Ohne Lizenz weitermachen"
  überspringen, solange die Testphase läuft.
- **Installation und Updates brauchen keine Anmeldung mehr** an der Registry. Ein
  vorhandenes Zugangstoken stört nicht, wird aber nicht mehr benötigt — und kann eine
  Installation dadurch auch nicht mehr von Sicherheitsupdates abschneiden.
- **`install.sh` meldet Zustände jetzt im Klartext.** Eine laufende Schemamigration und
  eine fehlende Lizenzdatei liefen bisher stillschweigend in ein Zeitlimit von drei
  Minuten, obwohl der Server längst antwortete.
- Am Lizenzmodell selbst ändert sich nichts: eine Lizenz je Installation, beim Einspielen
  an sie gebunden, nach dem Ablauftag sieben Tage Übergangsfrist.
- Die Anleitungen `LIESMICH.md` und `BETRIEB.md` sind nachgezogen.

## NETbrain 0.4.0

**Stand:** 9. September 2026

**Status:** Enthält auch die nie veröffentlichte 0.3.0 — bricht den Installationsweg `--tls`

Der Schwerpunkt liegt auf der Wissenssuche, der Verwaltung der KI-Zugänge und darauf,
dass die Oberfläche auf großen Bildschirmen wieder angemessen wirkt. Bestehende Daten
und Konten bleiben beim Update erhalten; einzurichten ist nichts — außer bei einer
Installation, die mit `--tls` aufgesetzt wurde.

**Wer von 0.2.1 kommt, erhält zugleich die Änderungen der 0.3.0.** Diese Fassung wurde nie
veröffentlicht; ihre Notizen stehen unten und gelten unverändert. Der Punkt daraus, der
Arbeit macht: NETbrain bringt keinen Reverse-Proxy mehr mit — TLS, Zertifikat und
Erneuerung liegen beim Betreiber.

### Die Suche findet Wortvarianten und benannte Dinge

- **Andere Worte, dieselbe Sache.** Wer nach „Urlaub" fragt, findet auch Seiten, die von
  „Erholungsurlaub" sprechen — ebenso bei Passwort/Kennwort, Datensicherung/Backup/
  Sicherungskopie, Laptop/Notebook und Fernzugang/Remotezugang. Enge Begriffe bleiben
  eng: „Sonderurlaub" gilt weiterhin nicht als gewöhnlicher Urlaub.
- **Namen von Kunden, Projekten, Systemen und Produkten** werden als eigener
  Suchgegenstand behandelt. Eine Frage nach zwei Kunden verlangt einen Nachweis für
  jeden — statt einer Antwort, die nur einen von beiden belegt.
- **Lieber eine Wissenslücke als eine Ersatzseite.** Ist der gefragte Name im
  freigegebenen Bestand nicht belegt, sagt NETbrain das, anstatt thematisch verwandte
  Seiten anzubieten, die die Frage nicht beantworten.

Gemessen an einem Katalog aus 33 Fragen mit hinterlegten Belegstellen: alle 33
bestanden, jede erwartete Quelle gefunden und jeder Beleg im an die KI übergebenen
Ausschnitt enthalten. Der Prüfbestand liegt beim Hersteller und enthält keine
Kundendaten.

### Wissenslandkarte: „Ohne Tag" heißt jetzt wirklich „ohne Tag"

Die Karte hatte eine Sammelgruppe für zwei verschiedene Fälle — Seiten ohne jeden Tag
und Seiten, deren Tags zu selten für einen Platz in der Legende sind. Eine Seite mit
Tags konnte deshalb unter der Aufschrift „Weitere / ohne Tag" landen. Es sind nun zwei
getrennte Gruppen, **„Ohne Tag"** und **„Weitere Tags"**. Damit ist „Ohne Tag" eine
brauchbare Arbeitsliste für die Wissenspflege.

### Interne KI vollständig über die Oberfläche einrichtbar

- **Adresse und Schlüssel des internen KI-Servers** werden in *Administration →
  KI-Zugänge* gepflegt. Bisher musste die Adresse in der Umgebung des Containers
  stehen. Ist sie dort gesetzt, bleibt sie es und das Feld zeigt sie als extern
  vorgegeben an.
- **Ohne eingerichtete interne KI gibt es sie auch nicht zur Auswahl.** Der Schalter
  *Intern / Cloud* in den Erfassungsformularen und der interne Anbieter im Chat
  erscheinen nur, wenn Adresse und Modell tatsächlich hinterlegt sind. Vorher stand die
  Auswahl auch bei einer reinen Cloud-Installation da und führte in eine Fehlermeldung.
- **Ein neu eingetragenes internes Modell wirkt überall.** Es steht danach nicht nur im
  KI-Chat, sondern auch beim Einreichen von Firmenwissen und in der privaten Erfassung
  zur Verfügung.
- **Die Auftragsmodelle** (Schnell erfassen, Einarbeiten, Rückfragen, Bilder lesen)
  lassen sich je Anbieter getrennt einstellen; die Ansicht bleibt nach dem Speichern
  beim gewählten Anbieter.

### Nur Modelle, die die Datenschutzvorgaben erfüllen

Für Cloud-Anbieter, die es angeben, prüft NETbrain je Modell vier Punkte: keine
Speicherung der Eingaben, keine Verwendung zum Training, Hosting in der EU und ein
nicht überschrittenes Enddatum. Wer eine dieser Angaben nicht macht, wird nicht
angeboten — eine fehlende Angabe gilt als Nein, nicht als Ja. Aus dem Katalog des
Anbieters Requesty bleiben damit 167 von rund 700 Modellen; fünf abgelaufene Modelle
waren zuvor weiterhin auswählbar.

Anbieter, deren Katalog diese Felder überhaupt nicht führt — der interne Server,
Anthropic, eigene Endpunkte — werden davon nicht gefiltert. Bei einem Server im eigenen
Haus entscheidet ohnehin nicht ein Feld in einer Schnittstelle, sondern der Standort.

### Rückmeldungen gehen an den Hersteller

„Feedback geben" schickt Fehlerberichte und Ideen nun direkt an den Hersteller, statt
sie nur in der eigenen Installation abzulegen. **Ohne Mandantenbezug:** Übertragen
werden Art, Betreff und Text, nicht Ihr Name, nicht Ihre Kontokennung und nicht der
Name Ihrer Installation. Wer eine Antwort möchte, kann freiwillig eine Kontaktangabe
ins Formular schreiben — sie ist das einzige personenbezogene Feld und bleibt leer,
wenn Sie es so wollen.

### Hinweis zur Alpha-Version

Der Schriftzug „Alpha-Version" oben links öffnet jetzt einen ausführlichen Hinweis
darüber, was diese Fassung leisten soll, was sie nicht ist und wie es um Gewährleistung
und Haftung steht — statt wie vorher das Feedback-Formular. Der Hinweis zeigt sich
**einmal je Konto** beim ersten Arbeiten von selbst und ist danach jederzeit über
denselben Schriftzug erreichbar. Die Bestätigung hängt am Konto, nicht am Browser: Ein
Gerätewechsel oder gelöschte Browserdaten holen den Hinweis nicht zurück.

### Oberfläche und Bedienung

- **Auf großen Bildschirmen wächst die Schrift mit.** Ab 1600 px und noch einmal ab
  2200 px Fensterbreite rückt die gesamte Schriftskala eine Stufe hoch. Auf kleineren
  Bildschirmen ändert sich nichts.
- **Die Seite läuft nicht mehr über.** Kopfzeile und Hinweisstreifen wurden vom
  Arbeitsbereich mit einer festen Zahl verrechnet; jeder zusätzliche Streifen und ein
  langer Seitenbaum in der Spalte machten die Startseite dadurch höher als das Fenster.
  Die Höhen werden nun gemessen statt angenommen.
- **Eindeutige Symbole:** KI-Aktionen tragen durchgehend das Hirn-Symbol, die Suche eine
  Lupe.

### Fehlerbehebungen

- **„Einarbeiten lassen" funktionierte nie.** Der Knopf in der Inbox führte auf eine
  Seite „nicht gefunden". Behoben; die Funktion samt Fortschrittsanzeige und Abbruch ist
  damit erstmals benutzbar.
- **Ein Verbindungsfehler nennt seinen Grund und den Hostnamen.** „Der KI-Dienst ist
  nicht erreichbar" unterschied nicht zwischen einem abgeschalteten Anbieter, einem
  falschen Zertifikat und einem Namen, der sich nicht auflösen lässt. Die vier Fälle
  werden jetzt getrennt benannt — samt Hinweis, wo *nicht* zu suchen ist.
- **Eine laufende Chat-Antwort belegt ihren Platz im Kontingent bis zum Ende.** Zuvor
  wurde er freigegeben, sobald die Antwort zu strömen begann; mehrere gleichzeitige
  Antworten konnten die Grenze dadurch überschreiten.
- **Ein Scan ohne lesbaren Text** führt zu einer Rückfrage statt zu einem Abbruch: Der
  Einwurf bittet um eine kurze Beschreibung, und das Original bleibt als Nachweis
  erhalten.
- **Der interne KI-Anbieter durfte fehlen** — eine reine Cloud-Installation meldete sich
  an mehreren Stellen als nicht bereit, obwohl nichts fehlte.

### Für Administratoren

- **Lizenzen werden beim Hersteller aktiviert.** Eine Installation bindet ihre Lizenz an
  sich selbst und erneuert sie regelmäßig; fällt der Lizenzdienst aus, läuft der Betrieb
  eine Woche unverändert weiter, bevor überhaupt ein Hinweis erscheint.
- **Nach einem Deployment wird geprüft, ob die Modelle antworten.** Die Modellliste eines
  Anbieters beweist nichts; nur ein Aufruf tut das. Von Hand geht dasselbe über „Modelle
  jetzt prüfen" in *Administration → KI-Zugänge*.
- **Der Nameserver des Containers steht fest in der Compose-Datei.** Startete der Server
  neu, bevor das Netz stand, hatte der Container keinen Nameserver und erreichte keinen
  einzigen KI-Anbieter mehr — an einem realen Fall zwei Tage lang.

### Bekannte Einschränkung

Ein **eigener KI-Zugang** unter einer Adresse, die keine Modellliste (`/v1/models`)
anbietet, bleibt unbenutzbar: Die Auswahl bleibt leer und der Sendeknopf inaktiv. Ein
Modellname lässt sich dort noch nicht von Hand eintragen.

---

## NETbrain 0.3.0

**Stand:** 2. September 2026

**Status:** Bricht den Installationsweg `--tls`

### NETbrain bringt keinen Reverse-Proxy mehr mit

Bisher konnte `install.sh --tls <hostname>` einen Caddy davorstellen, der sich sein
Zertifikat selbst holte. Dieser Weg ist entfallen. NETbrain spricht im Container HTTP;
HTTPS, Zertifikat und deren Erneuerung liegen beim Betreiber.

**Was Sie einrichten müssen**, steht vollständig in `BETRIEB.md`, Abschnitt „Anforderungen
an Ihren Reverse-Proxy" — mit einem kopierfertigen nginx-Beispiel. Die Kurzfassung: TLS
beenden, Port 80 auf 443 weiterleiten, mindestens 12 MB Request-Body durchlassen,
`X-Forwarded-For` setzen, Port 4321 per Firewall auf die Adresse Ihres Proxys beschränken
und Ihren DNS-Namen in `NETBRAIN_ALLOWED_HOSTS` eintragen.

### Wenn Sie bisher mit `--tls` installiert haben

Ihre Installation läuft weiter — `install.sh` hat Ihre `netbrain-compose.yml` nie
überschrieben, und der Caddy-Container darin bleibt unangetastet. Zwei Dinge ändern sich
trotzdem:

- **Ihr Update-Befehl funktioniert nicht mehr.** `install.sh --tls <hostname>` bricht jetzt
  mit `Unbekannte Option »--tls«` ab. Aktualisieren Sie stattdessen ohne die Option; Ihre
  Compose-Datei mit dem Proxy-Dienst bleibt dabei erhalten.
- **Löschen Sie Ihre `netbrain-compose.yml` nicht**, um die Vorgabe zurückzubekommen. Die
  neu erzeugte Datei enthält keinen Proxy. Ihr Caddy-Container liefe dann als Waise weiter,
  hielte die Ports 80 und 443 besetzt, und Ihre Installation wäre nicht mehr erreichbar,
  ohne dass etwas defekt aussieht.

### NETbrain kann HSTS jetzt selbst

`Strict-Transport-Security` kam vorher aus dem mitgelieferten Caddy. Setzt Ihr Proxy den
Header nicht, können Sie ihn in NETbrain einschalten: `NETBRAIN_HSTS=true` in der `.env`
neben den Compose-Dateien, dann Container neu starten.

**Voreinstellung ist aus, und das mit Absicht.** Ein HSTS-Header auf einem falschen Namen
oder hinter einem Proxy, der nur HTTP spricht, sperrt die Domain für ein Jahr aus, und keine
Konfigurationsänderung holt das zurück. Schalten Sie ihn erst ein, wenn HTTPS unter dem
endgültigen Namen steht und funktioniert.

---

## NETbrain 0.2.1

**Stand:** 31. August 2026

**Status:** Korrekturrelease zu 0.2.0

Zwei Korrekturen am Installationsweg. An der Anwendung selbst ändert sich
nichts; wer 0.2.0 bereits im Browser benutzt, merkt keinen Unterschied.

### Korrekturen

- **`install.sh` bezog das Image aus der falschen Registry.** Voreingestellt
  war eine private Ablage aus der Entwicklungszeit, die einem Kunden nicht
  zugänglich ist — die Installation brach beim Herunterladen ab. Sie zeigt nun
  auf `ghcr.io/netfactory-gmbh/netbrain`.

- **Die Einrichtungsmeldung nannte eine Adresse, unter der nichts antwortet.**
  Eine Installation ohne `--tls` ist ausschließlich lokal erreichbar; das
  Protokoll nannte trotzdem den Rechnernamen des Servers („Erreichbar unter:
  https://<rechnername>"). Wer dieser Angabe folgte, landete im Nichts und
  musste annehmen, die Installation sei fehlerhaft. Eingetragen werden jetzt
  nur Namen, unter denen die Installation tatsächlich antwortet: bei `--tls`
  der angegebene Hostname, bei einer Veröffentlichung auf allen Netzwerkkarten
  der Rechnername, sonst nur `localhost`. Zusätzliche Namen — etwa der eines
  vorhandenen Reverse-Proxys — werden wie bisher im Einrichtungsassistenten in
  Schritt 3 nachgetragen.

### Hinweis für eine bereits vorhandene Installation

`install.sh aktualisieren` lässt eine vorhandene `netbrain-compose.yml`
unangetastet — sie gehört dem Betreiber, samt seiner Eintragungen. Die zweite
Korrektur greift deshalb nur bei einer Neuinstallation. Wer 0.2.0 schon per
`install.sh` aufgesetzt hat und die falsche Adresse im Protokoll sieht,
entfernt den Rechnernamen in der Zeile `NETBRAIN_ALLOWED_HOSTS` seiner
`netbrain-compose.yml` von Hand und startet neu. Alternativ die Datei löschen
und `install.sh installieren` erneut aufrufen; die Daten bleiben dabei
erhalten.

---

## NETbrain 0.2.0

**Geplanter Stand:** 28. August 2026  

**Status:** Release Candidate

NETbrain 0.2.0 macht aus der bisherigen Pilotinstallation eine deutlich besser
bedienbare und betreibbare Wissensplattform. Im Mittelpunkt stehen die
KI-Verwaltung, Spracheingabe sowie ein verlässlicherer Arbeitsfluss im Chat und
in der Kuratur.

### Neue Funktionen

### Einfacher installieren und betreiben

- Die Erstinstallation führt nun durch die grundlegende Einrichtung, ohne dass
  dafür ein Benutzer auf der Kommandozeile angelegt werden muss.
- Installation, Lizenz, Einrichtungstoken und Betriebsdaten sind für den
  Betrieb im Container vorbereitet.
- Datenmigrationen laufen beim Start automatisch. Tägliche Sicherungen und eine
  Auslieferungsprüfung reduzieren den manuellen Betriebsaufwand.
- Jeder KI-Aufruf schreibt eine Protokollzeile mit Zweck, Anbieter, Modell,
  Dauer und Ausgang – auch dann, wenn er fehlschlägt. Inhalte, Eingaben und
  Schlüssel stehen nicht darin. Damit sind langsame Modelle und abgebrochene
  Aufträge im Betrieb nachvollziehbar.
- Die Websuche kann über einen eigenen SearXNG-Dienst betrieben werden;
  Einstellungen aus Compose-Overlays bleiben beim Deployment erhalten.
- Administratoren werden dezent über neue NETbrain-Versionen informiert und
  können sie im Browser installieren. Vorher läuft automatisch eine
  verschlüsselte Sicherung; Gesundheitsprüfung und Rückkehr zum bisherigen
  Image sind Teil desselben Ablaufs.

### Zentrale KI-Verwaltung

- Die Seite **Administration → KI-Zugänge** bündelt KI-Aufträge, Anbieter,
  Modelle, Rollenfreigaben, Kontoausnahmen, Wissensregeln und den
  Änderungsverlauf an einem Ort.
- Für die Aufgaben *Schnell erfassen*, *Einarbeiten*, *Rückfragen zum
  Firmenwissen* und *Bilder lesen* lassen sich eigene Modelle festlegen.
- Eingestellte Auftragsmodelle können direkt in der Administration geprüft
  werden. Das erleichtert die Diagnose nach Modell- oder Anbieterwechseln.
- Große Modelllisten sind nach Anbieter gruppiert, einklappbar und durchsuchbar;
  bereits gesetzte Freigaben bleiben beim Filtern erhalten.
- **Mistral** ist als weiterer Cloud-Anbieter angebunden. Der Schlüssel wird wie
  bei den übrigen Anbietern im Einrichtungsassistenten oder verschlüsselt in der
  Administration hinterlegt; ohne gesetzte Häkchen ist kein Modell freigegeben.
- Die Freigabeliste zeigt den vollständigen Modellkatalog des Anbieters. Auch
  bei Anbietern mit sehr vielen Modellen lässt sich jedes davon freigeben.
- Für interne, denkende Modelle kann der Gedankengang bei strukturierten
  Aufgaben abgeschaltet werden. Aufbereitung und Bildanalyse werden dadurch
  schneller und laufen seltener in die Ausgabegrenze.

### Spracheingabe

- Nachrichten können im Chat diktiert werden.
- Auch die **private** und die **Firmen-Erfassung** haben einen Mikrofonknopf am
  Inhaltsfeld. Dort darf eine Aufnahme bis zu zehn Minuten laufen, weil eine
  Gesprächsnotiz länger ist als eine Chatnachricht.
- Diktiertes wird an der Schreibmarke eingesetzt, nicht anstelle des bisherigen
  Textes: Getipptes und Gesprochenes lassen sich mischen.
- Neben **Stopp** gibt es einen **Pause**-Knopf. Er schließt den laufenden
  Abschnitt ab, setzt den erkannten Text sofort ins Feld und lässt das Mikrofon
  offen; **Weiter** nimmt den nächsten Abschnitt auf. So lässt sich ein längeres
  Diktat abschnittsweise mitlesen und korrigieren, statt erst am Ende.
- Kommt vom Mikrofon kein Ton, wird die Aufnahme nicht verschickt. Der Chat und
  die Erfassung sagen das schon während der Aufnahme („noch kein Ton") und
  nennen danach den Grund. Zuvor lieferte die Spracherkennung bei stummem
  Eingang eine unverfängliche Floskel, die wie ein Ergebnis aussah.
- Das Modell für die Spracherkennung wird zentral ausgewählt. Ohne konfigurierte
  Spracheingabe bleibt die Funktion ausgeblendet.
- Der Chat zeigt verständlich an, wenn die Erkennung nicht verfügbar ist oder
  eine Aufnahme nicht verarbeitet werden konnte.

### Besserer Arbeitsfluss im Chat und in der Kuratur

- Laufende Chat-Antworten lassen sich stoppen. Bereits empfangener Text bleibt
  erhalten und wird als unvollständig gekennzeichnet.
- Das automatische Einarbeiten eines Inbox-Beitrags zeigt einen sichtbaren
  Arbeitsstatus und kann vor dem Übernehmen abgebrochen werden.
- Die Erfassung im privaten Vault meldet ihren Fortschritt laufend („Der Scan
  wird gelesen …", „Der Inhalt wird aufbereitet …"). Auch mehrseitige Scans
  laufen dadurch hinter einem vorgelagerten Proxy zu Ende, statt nach dessen
  Wartezeit als Zeitüberschreitung zu enden.
- Die Chat-Leiste ist auf schmalen Bildschirmen kompakter: Kontext und
  Arbeitsmodus werden über eindeutige Symbole bedient und bleiben für
  Screenreader beschriftet.

### Erscheinungsbild

- Logos, Favicon und Vorschaubild wurden auf die Marke **NETbrain** vereinheitlicht.

### Verbesserungen und Fehlerbehebungen

- Eine Antwort, die bei einer strukturierten KI-Aufgabe an der Ausgabegrenze
  abgeschnitten wird, erhält nun eine konkrete, hilfreiche Meldung statt eines
  allgemeinen Wiederholungs-Hinweises.
- Zeitüberschreitungen werden nicht mehr wiederholt. Dadurch entsteht keine
  doppelte Wartezeit bei einem langsamen Modell.
- Fehlgeschlagene Aufbereitung und Einarbeitung schreiben Anbieter und
  Modellname in das Serverprotokoll; im Browser erscheinen sichere, verständliche
  Hinweise statt interner Anbietermeldungen. Das gilt nun für jeden KI-Aufruf:
  Der Wortlaut der Anbieterantwort – der bei abgelaufenen Schlüsseln Teile des
  Schlüssels enthalten kann – bleibt im Serverprotokoll.
- Bricht ein vorgelagerter Proxy die Verbindung ab, erscheint eine
  verständliche Meldung mit Hinweisen zum weiteren Vorgehen statt der
  HTML-Fehlerseite des Proxys. Das gilt für die private Erfassung, die
  Wissenssuche und den Chat.
- Die Modellfreigabe wirkt jetzt auch für den internen Anbieter und Requesty.
  Bisher standen dort alle entdeckten Modelle zur Auswahl, unabhängig von den
  gesetzten Häkchen.
- Die Markenschreibweisen zeigen bei Vorgabe über die Umgebung den vollständigen
  Wert samt Variablennamen an, statt ein gesperrtes Feld mit abgeschnittenem
  Text und einem wirkungslosen Speichern-Knopf. Textfelder in den
  Freigabe-Formularen sind wieder als Eingabefelder erkennbar.
- Die Spracheingabe verwendet den korrekten Endpunkt und zeigt Fehler der
  Transkription nachvollziehbar an.
- Die Mikrofonberechtigung wird nur dann per Permissions-Policy freigegeben,
  wenn Spracheingabe eingerichtet ist.
- In der Chat-Modellauswahl erscheinen nur tatsächlich chatfähige Modelle.
- Die Einrichtungsprüfung erkennt Schlüssel aus Umgebungsvariablen zuverlässig.
- Ein Sicherungs-Probelauf funktioniert auch dann, wenn noch keine Daten für ein
  Sicherungsbündel vorhanden sind.
- Die Lizenzdatei blockiert ein Deployment nicht mehr unnötig; Fehler im
  Lizenzwerkzeug sind verständlicher formuliert.

### Hinweise zum Update

- Für die Spracheingabe muss in **Administration → KI-Zugänge** ein
  Spracherkennungsmodell ausgewählt sein. Aufnahmen werden nur für die jeweilige
  Transkription verarbeitet und nicht gespeichert.
- Während einer Pause bleibt das Mikrofon geöffnet, damit der Browser nicht bei
  jedem „Weiter" erneut nach Erlaubnis fragt und ein anderes Gerät wählt. Die
  Aufnahmeanzeige des Browsers bleibt deshalb an; die Statuszeile weist darauf
  hin. Die Zeitgrenze von zehn Minuten gilt je Abschnitt.
- Der Schalter **Intern/Cloud** in den Erfassungsformularen steuert die
  Aufbereitung des Beitrags, nicht die Spracherkennung: Diktate gehen immer an
  den zentral eingestellten Spracherkennungsdienst. Welcher das ist, steht im
  Hinweistext des Mikrofonknopfs.
- Der Schalter zum Abschalten des Gedankengangs gilt ausschließlich für den
  internen KI-Anbieter und nur für strukturierte Aufträge, nicht für normale
  Chat-Antworten.
- Das Stoppen einer laufenden KI-Anfrage beendet die Wartezeit im Browser. Eine
  beim Anbieter bereits gestartete Berechnung kann dennoch weiterlaufen.

---

### Versionshinweis

Version **0.2.0** ist das erste größere, abwärtskompatible Funktionsupdate nach
dem Pilotstand 0.1.0. Bestehende Daten und Konten bleiben beim Update erhalten.

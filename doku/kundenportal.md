# Kundenportal

Mit dem Kundenportal geben Sie einzelne Wissensseiten für Ihre Kunden frei: Anleitungen, Antworten auf häufige Fragen, Produktwissen. Das Portal zeigt sie ohne Anmeldung, mit Suche, unter einer eigenen Adresse. Es ist Teil Ihrer Lizenz, sofern diese das Portal enthält; die Testlizenz enthält es.

## So funktioniert es

Das Portal ist ein **eigener, kleiner Container**. Er enthält keinen NETbrain-Code und hat keinen Zugriff auf Ihre Installation. NETbrain schiebt den freigegebenen Stand zu ihm hin — signiert mit einem Kopplungsschlüssel —, das Portal holt nichts ab. NETbrain muss das Portal also erreichen können, umgekehrt nicht.

- Freigegeben wird **der Stand zum Zeitpunkt der Freigabe**. Ändert jemand die Seite danach, geht die Änderung nicht unbemerkt hinaus: NETbrain zeigt „die Seite wurde seitdem geändert“, und Sie veröffentlichen den neuen Stand bewusst.
- Links zeigen nur auf ebenfalls freigegebene Seiten; Verweise auf Unveröffentlichtes werden zu Text. Nachweise, Anhänge und interne Angaben gehen nicht mit.
- NETbrain gleicht bei jeder Freigabe und alle zehn Minuten ab. Läuft die Lizenz aus und gleicht NETbrain nicht mehr ab, verschwinden die Inhalte nach acht Tagen von selbst.

## Portal mit dem Installer einrichten

Am einfachsten richtet der Installer das Portal neben NETbrain ein, im selben Compose-Projekt:

```
# neu installieren oder aktualisieren, samt Portal
curl -fsSL https://getnetbrain.netfactory.de/install.sh | sudo bash -s -- --portal

# in einer bestehenden Installation nachrüsten (ab 0.5.6)
sudo /opt/netbrain/install.sh portal
```

Er legt `portal-compose.yml` und den Kopplungsschlüssel in `portal.env` an, startet das Portal auf `127.0.0.1:8080` und zeigt am Ende Adresse und Schlüssel zum Eintragen. NETbrain erreicht das Portal intern unter `http://portal:8080`; für Ihre Kunden stellen Sie einen Reverse-Proxy mit eigenem Hostnamen davor und tragen danach die öffentliche Adresse (`https://…`) in NETbrain ein, damit Sitemap und Suchmaschinen die richtigen Links bekommen. Jeder weitere Lauf von `install.sh` aktualisiert auch das Portal.

## Portal-Container von Hand starten

Das Image ist öffentlich: `ghcr.io/netfactory-gmbh/netbrain-portal`. Es spricht HTTP auf Port 8080; TLS übernimmt Ihr Reverse-Proxy, unter einem eigenen Hostnamen wie `wissen.ihre-firma.de`.

Der Kopplungsschlüssel verbindet beide Seiten. Er entsteht auf einem von zwei Wegen:

- **Sie wählen ihn selbst**, etwa mit `openssl rand -base64 32`, starten das Portal damit und tragen ihn in NETbrain unter **Schlüssel eintragen** ein. So arbeitet auch eine App-Plattform, die den Schlüssel vorgibt.
- **NETbrain erzeugt ihn** über **Schlüssel erzeugen**. Er erscheint einmal; kopieren Sie ihn gleich und setzen Sie ihn im Portal.

Die Schritte:

1. Den Container mit dem Schlüssel starten:

```
docker run -d --name netbrain-portal --restart unless-stopped \
  -p 127.0.0.1:8080:8080 -v netbrain-portal-data:/data \
  -e PORTAL_SYNC_KEY='<schlüssel>' \
  ghcr.io/netfactory-gmbh/netbrain-portal:latest
```

2. Den Reverse-Proxy für den Portal-Hostnamen auf Port 8080 einrichten.
3. In NETbrain unter **Administration → Kundenportal** die Adresse des Portals eintragen und speichern.
4. Den Schlüssel unter **Schlüssel eintragen** einfügen und **Schlüssel übernehmen**. NETbrain gleicht sofort ab; die Meldung nennt, wie viele Seiten übertragen wurden.

Dieselben Felder bietet schon der Einrichtungsassistent im Schritt Kundenportal.

Läuft das Portal auf demselben Docker-Host wie NETbrain, können Sie beide in ein gemeinsames Netz hängen und als Adresse `http://netbrain-portal:8080` eintragen; dann geht der Abgleich nicht über den Proxy.

## Seiten freigeben

Mitglieder der Wissenspflege sehen auf jeder Wissensseite unter der Kurzfassung die Zeile **Kundenportal**:

- **Im Kundenportal veröffentlichen** — nach einer Bestätigung ist die Seite öffentlich lesbar.
- **Aktuellen Stand veröffentlichen** — erscheint, wenn die Seite seit der Freigabe geändert wurde.
- **Zurückziehen** — die Seite verschwindet beim nächsten Abgleich aus dem Portal.
- **Rubrik** — ordnet die Seite im Portal ein, etwa „myfactory“ oder „Konto & Zugang“. Bei der ersten Freigabe ist der Ordnername vorgeschlagen; **Rubrik ändern** gilt sofort, ohne den Inhalt neu zu veröffentlichen. Seiten ohne Rubrik stehen unter „Weitere Artikel“.

## Aufbau des Portals

Das Portal ist wie ein Wiki aufgebaut. Links steht eine Seitenleiste mit allen Rubriken und ihren Artikeln, auf dem Handy als aufklappbarer Block. Die Startseite zeigt die Rubriken als Kacheln und darunter die zuletzt aktualisierten Artikel; jede Rubrik hat eine eigene Seite mit den Kurzfassungen ihrer Artikel, und **Alle Artikel A–Z** listet alles alphabetisch. Ein Artikel zeigt den Weg zurück zur Rubrik, rechts „Auf dieser Seite“ mit seinen Zwischenüberschriften, darunter die Artikel, die auf ihn verweisen, und weitere Artikel derselben Rubrik. Die Suche hebt die Suchwörter hervor und nennt die Rubrik jedes Treffers.

Unter **Administration → Kundenportal** stehen alle freigegebenen Seiten mit Rubrik und dem Hinweis, wenn eine Seite seit der Freigabe geändert wurde, ebenfalls mit **Zurückziehen**. Legt jemand eine freigegebene Seite in den Papierkorb, wird auch die Freigabe zurückgezogen.

## Erscheinungsbild

Unter **Administration → Kundenportal → Erscheinungsbild** passen Sie das Portal an Ihr Haus an:

- **Name in der Kopfzeile** und **Einleitung** auf der Startseite,
- **Logo** — PNG, JPEG oder WebP bis 512 KB; ohne eigenes Logo erscheint das NETbrain-Logo,
- **Akzentfarbe** für Knöpfe und Links — ist sie auf dem Hintergrund schlecht lesbar, gleicht das Portal die Linkfarbe selbst ab,
- **Design** hell oder dunkel,
- **Impressum**, **Datenschutzerklärung** und **Kontaktadresse** — sie stehen in der Fußzeile.

> [!WICHTIG] Impressum nicht vergessen
> Ein öffentlich erreichbares Portal Ihres Unternehmens braucht in der Regel ein Impressum und eine Datenschutzerklärung. Verweisen Sie auf die Seiten Ihres Webauftritts.

Nach dem Speichern gleicht NETbrain sofort ab. Logo und Einstellungen liegen bei den Portal-Freigaben und sind damit Teil der Sicherung.

## Suchmaschinen

Standardmäßig bittet das Portal Suchmaschinen, es nicht aufzunehmen. Sollen Ihre Inhalte gefunden werden, setzen Sie unter **Administration → Kundenportal** das Häkchen für Suchmaschinen. Das Portal nennt dann unter `/sitemap.xml` alle Rubriken und Artikel und gibt jeder Seite ihre öffentliche Adresse als kanonische Adresse mit.

## Auf einer App-Plattform

Was die Plattform für den Portal-Container bereitstellen muss, steht unter [Kubernetes und App-Plattformen](plattform.html#kundenportal).

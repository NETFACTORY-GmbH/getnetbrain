# Voraussetzungen

Bitte gehen Sie diese Liste vor der Installation durch. Jeder Punkt kostet hinterher mehr Zeit als jetzt.

## Server

- Linux-Server oder VM, aktuelles LTS (Debian oder Ubuntu empfohlen).
- **Docker Engine** und **Docker Compose v2** (`docker compose version` — mit Leerzeichen). Fehlt Docker, bietet der Installer an, es über das offizielle Skript von Docker einzurichten.
- **2 vCPU und 4 GB RAM** als Richtwert. NETbrain rechnet kaum selbst; die Sprachmodelle laufen beim KI-Anbieter.
- **40 GB Platte** als Start. Wissensbestand und Sicherungen wachsen unabhängig voneinander; NETbrain hebt in der Vorgabe 14 Sicherungsstände auf.
- `sudo`-Rechte.

## Netz

- Ein **DNS-Name**, der auf den Server zeigt, zum Beispiel `netbrain.ihre-firma.de`. Ein reiner Intranet-Name genügt.
- **Ausgehend Port 443** zur Container-Registry `ghcr.io` (Installation und Updates), zum Lizenzdienst `lizenz-netbrain.netfactory.de` und zu Ihrem KI-Anbieter. Was genau übertragen wird, steht unter [Was den Server verlässt](datenfluss.html).
- **Eingehend** nur auf Ihren Reverse-Proxy (443, dazu 80 für die Weiterleitung). Auf dem NETbrain-Server selbst muss von außen nichts offen sein.

## Reverse-Proxy mit TLS

NETbrain spricht im Container HTTP und ist nur auf `127.0.0.1` erreichbar. Davor gehört ein Reverse-Proxy, den Sie stellen: Er nimmt HTTPS an, beendet TLS und reicht an NETbrain weiter.

> [!WICHTIG] Ohne HTTPS keine Anmeldung
> Das Sitzungscookie von NETbrain ist `secure`. Über reines HTTP verwirft es der Browser, und die Anmeldung scheitert trotz richtigem Passwort.

Was der Proxy genau leisten muss — acht Punkte samt nginx-Beispiel — steht unter [Reverse-Proxy](reverse-proxy.html). Klären Sie vorab mit Ihrem Netzbetrieb, wer was einrichtet.

## Unterlagen und Zugänge

- Ein **Passwortmanager**, offen und bereit: Bei der Einrichtung erzeugt NETbrain eine Sicherungs-Passphrase und zeigt sie genau einmal.
- Zugangsdaten zu Ihrem **KI-Anbieter** (Adresse und Schlüssel), sofern Sie den KI-Chat nutzen.
- Ihre **Lizenzdatei**, falls schon vorhanden. Ohne sie läuft NETbrain sieben Tage; danach genügt eine Testlizenz, die Sie im Assistenten selbst anfordern.
- Für Sicherungen außerhalb des Servers: ein Ziel in Ihrem bestehenden Sicherungsverfahren.

## Auf einer App-Plattform statt auf eigenem Server

Betreiben Sie NETbrain auf Kubernetes oder einer App-Plattform, entfallen Installer und Reverse-Proxy-Einrichtung. Was die Plattform stattdessen bereitstellen muss, steht unter [Kubernetes und App-Plattformen](plattform.html).

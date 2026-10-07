# NETbrain-Dokumentation

Hier finden Sie alles, um NETbrain zu installieren, einzurichten, im Team zu nutzen und dauerhaft zu betreiben. Die Dokumentation beschreibt NETbrain 0.4.16.

<div class="karten">
<a class="karte" href="installation.html"><b>In 45 Minuten startklar</b><span>Ein Befehl auf dem Server, danach führt ein Assistent im Browser durch die Einrichtung.</span></a>
<a class="karte" href="firmenwissen.html"><b>Firmenwissen nutzen</b><span>Wissen einwerfen, prüfen lassen, wiederfinden — für alle im Team.</span></a>
<a class="karte" href="sicherung.html"><b>Sicher betreiben</b><span>Verschlüsselte Sicherungen, Wiederherstellung und Updates mit einem Klick.</span></a>
<a class="karte" href="fehlerbehebung.html"><b>Etwas klappt nicht?</b><span>Die häufigsten Meldungen und was dahintersteckt.</span></a>
</div>

## Was NETbrain ist

NETbrain ist eine Wissensplattform für Unternehmen. Sie läuft als **ein Container auf Ihrem Server** und wird im Browser bedient. Drei Bereiche gehören dazu:

- **Firmenwissen** — der gemeinsame, geprüfte Bestand. Jeder darf einwerfen, die Wissenspflege gibt frei.
- **Privater Vault** — persönliche Notizen in einem Ordner auf dem Rechner des Mitarbeiters.
- **KI-Chat** — Fragen an das Firmenwissen, mit einem KI-Anbieter Ihrer Wahl. Der Verlauf ist verschlüsselt.

Optional kommt ein **Kundenportal** hinzu: Ausgewählte Wissensseiten erscheinen dort öffentlich, ohne Anmeldung.

## Der Weg zur laufenden Installation

1. [Voraussetzungen](voraussetzungen.html) klären: Linux-Server mit Docker, DNS-Name, Reverse-Proxy mit TLS.
2. [Installieren](installation.html): ein Befehl, rund zehn Minuten.
3. [Im Browser einrichten](einrichtung.html): Token, Geheimnisse, KI-Anbieter, Sicherung, Lizenz, erster Administrator.
4. [Benutzer anlegen](benutzer.html) und loslegen.

Die ersten **sieben Tage** läuft NETbrain ohne Lizenz. Danach fordern Sie im Assistenten selbst eine Testlizenz über 30 Tage an oder hinterlegen Ihre gekaufte — siehe [Lizenz](lizenz.html).

## Für wen welche Seite

| Sie sind … | Lesen Sie zuerst |
|---|---|
| IT / Betrieb | [Voraussetzungen](voraussetzungen.html), [Reverse-Proxy](reverse-proxy.html), [Sicherung](sicherung.html) |
| Administrator in NETbrain | [Einrichtung](einrichtung.html), [Benutzer und Rollen](benutzer.html), [KI-Zugänge](ki-zugaenge.html) |
| Wissenspflege | [Firmenwissen](firmenwissen.html), [Wissenspflege](wissenspflege.html) |
| Mitarbeiter | [Anmeldung und Konto](anmeldung.html), [Firmenwissen](firmenwissen.html), [KI-Chat](ki-chat.html) |
| Plattformbetreiber (Kubernetes) | [Kubernetes und App-Plattformen](plattform.html) |
| Datenschutz | [Was den Server verlässt](datenfluss.html) |

## Hilfe

Fragen zur Installation, zum Betrieb oder zur Lizenz beantworten wir unter [info@netfactory.de](mailto:info@netfactory.de). Bitte schicken Sie bei technischen Fragen die Ausgabe von `sudo ./install.sh status` mit — das spart meist die erste Rückfrage.
